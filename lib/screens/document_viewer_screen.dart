// lib/screens/document_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document.dart';
import '../constants.dart';
import '../riverpod/providers/document_providers.dart';
import '../riverpod/notifiers/document_notifier.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  final TechnicalDocument? document;
  final String? documentId;
  final String? filePath; // Optional externally provided filePath

  const DocumentViewerScreen({
    super.key,
    this.document,
    this.documentId,
    this.filePath,
  }) : assert(document != null || documentId != null, 'Either document or documentId must be provided');

  @override
  ConsumerState<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends ConsumerState<DocumentViewerScreen> {
  String? _pdfPath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 1; // pdfx uses 1-indexed pages
  bool _hasError = false;
  String _errorMessage = '';
  late TechnicalDocument _document;

  // PDF controller
  PdfControllerPinch? _pdfController;

  // Returns the effective file path: uses the generated _pdfPath if available, otherwise falls back to widget.filePath.
  String get effectiveFilePath => _pdfPath ?? widget.filePath ?? '';

  @override
  void initState() {
    super.initState();
    
    // Initialize document from props or provider
    if (widget.document != null) {
      _document = widget.document!;
      _proceedWithDocumentLoading();
    } else if (widget.documentId != null) {
      // Get document from provider
      final doc = ref.read(documentByIdProvider(widget.documentId!));
      if (doc != null) {
        _document = doc;
        _proceedWithDocumentLoading();
      } else {
        // Document not in local cache, fetch from Firebase
        _fetchDocumentFromFirebase();
      }
    }
  }
  
  Future<void> _fetchDocumentFromFirebase() async {
    if (widget.documentId == null) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      // Use the document notifier to fetch the document
      final documentNotifier = ref.read(documentNotifierProvider.notifier);
      final doc = await documentNotifier.fetchDocumentById(widget.documentId!);
      
      if (doc != null) {
        _document = doc;
        _proceedWithDocumentLoading();
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Document not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to fetch document: $e';
        _isLoading = false;
      });
    }
  }
  
  void _proceedWithDocumentLoading() {
    // If no external filePath was provided, load the document.
    if (widget.filePath == null) {
      _loadDocument();
    } else {
      _initializePdfControllerWithPath(widget.filePath!);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  void _initializePdfControllerWithPath(String path) {
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(path),
    );
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // First check if the document is already downloaded
      final dir = await getApplicationDocumentsDirectory();
      // A document with an ID is present
      final String documentId = widget.document?.id ?? widget.documentId ?? '';
      final localPath = '${dir.path}/$documentId.pdf';
      final localFile = File(localPath);
      
      if (await localFile.exists()) {
        // Use the local file if it exists
        _initializePdfControllerWithPath(localPath);
        
        setState(() {
          _pdfPath = localPath;
          _isLoading = false;
        });
        return;
      }
      
      // If not locally available, automatically download using the document notifier
      if (!_document.isDownloaded) {
        try {
          debugPrint('Document not downloaded, auto-downloading: ${_document.id}');
          final documentNotifier = ref.read(documentNotifierProvider.notifier);
          await documentNotifier.downloadDocument(_document.id);
          
          // After download, try to load again
          if (await localFile.exists()) {
            _initializePdfControllerWithPath(localPath);
            
            setState(() {
              _pdfPath = localPath;
              _isLoading = false;
            });
            return;
          }
        } catch (downloadError) {
          debugPrint('Error auto-downloading document: $downloadError');
          // Continue to fallback methods
        }
      }
      
      // If not locally available, try to download from Firebase Storage directly
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('documents/${_document.id}.pdf');
            
        // Download to a temporary file
        await storageRef.writeToFile(localFile);
        
        // Initialize with the downloaded file
        _initializePdfControllerWithPath(localFile.path);
        
        setState(() {
          _pdfPath = localFile.path;
          _isLoading = false;
        });
        return;
      } catch (storageError) {
        debugPrint('Error downloading from Firebase: $storageError');
        // Fall back to asset loading if Firebase fails
      }
      
      // Try to use downloadURL if available
      if (widget.document?.downloadURL != null && widget.document!.downloadURL!.isNotEmpty) {
        try {
          final storageRef = FirebaseStorage.instance.refFromURL(widget.document!.downloadURL!);
          await storageRef.writeToFile(localFile);
          
          _initializePdfControllerWithPath(localFile.path);
          
          setState(() {
            _pdfPath = localFile.path;
            _isLoading = false;
          });
          return;
        } catch (e) {
          debugPrint('Error downloading from URL: $e');
          // Continue to next fallback
        }
      }
      
      // Fallback to loading from assets
      final String assetPath = widget.document!.filePath;
      debugPrint('Loading PDF from asset: $assetPath');
      final ByteData bytes = await rootBundle.load(assetPath);
      
      // Create a temporary file from the asset
      final tempFile = File(localPath);
      await tempFile.writeAsBytes(bytes.buffer.asUint8List());
      
      _initializePdfControllerWithPath(tempFile.path);
      
      setState(() {
        _pdfPath = tempFile.path;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('CRITICAL ERROR in _loadDocument: ${e.toString()} (${e.runtimeType})');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load document: $e';
        });
      }
    }
  }

  // Rest of the class remains the same...
  
  // Handle tap on the PDF
  void _handleTap(TapDownDetails details) async {
    // Show visual feedback for tap
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for links...'),
        duration: Duration(milliseconds: 500),
      ),
    );

    // In the current version of pdfx, directly getting link annotations might not be available
    // As a workaround, we'll extract links when the document is loaded and handle them separately

    // This is a simplified implementation - you may need to adapt it based on
    // your specific PDF structure and the version of pdfx you're using
    try {
      final uri = Uri.parse('https://costa.co.uk');  // Example URL
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error handling potential link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _document.title,
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Info button to explain PDF interactivity
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('PDF Navigation'),
                  content: const Text(
                      'You can zoom in/out using pinch gestures.\n\n'
                          'Unfortunately, direct link detection is limited in the current version. '
                          'Links in PDFs may need to be manually extracted for your specific documents.'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality would go here'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(costaRed),
              ),
            )
          else if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: accentRed,
                      size: 48.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _errorMessage,
                      style: CostaTextStyle.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _loadDocument,
                      style: primaryButtonStyle,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_pdfController != null)
              GestureDetector(
                onTapDown: _handleTap,
                child: PdfViewPinch(
                  controller: _pdfController!,
                  onDocumentLoaded: (document) {
                    setState(() {
                      _totalPages = document.pagesCount;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(costaRed),
                      ),
                    ),
                    pageLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(costaRed),
                      ),
                    ),
                    errorBuilder: (_, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: accentRed,
                            size: 48.0,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Error loading PDF: ${error.toString()}',
                            style: CostaTextStyle.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              const Center(child: Text('PDF file path is null')),

          // Page indicator
          if (!_isLoading && !_hasError && _totalPages > 0 && _pdfController != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Page $_currentPage of $_totalPages',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}