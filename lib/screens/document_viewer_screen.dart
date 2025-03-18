import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';
import '../constants.dart';

class DocumentViewerScreen extends StatefulWidget {
  final TechnicalDocument document;
  final String? filePath; // Optional externally provided filePath

  const DocumentViewerScreen({
    super.key,
    required this.document,
    this.filePath,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  String? _pdfPath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 1; // pdfx uses 1-indexed pages
  bool _hasError = false;
  String _errorMessage = '';
  
  // PDF controller
  PdfControllerPinch? _pdfController;

  // Returns the effective file path: uses the generated _pdfPath if available, otherwise falls back to widget.filePath.
  String get effectiveFilePath => _pdfPath ?? widget.filePath ?? '';

  @override
  void initState() {
    super.initState();
    // If no external filePath was provided, load the document.
    if (widget.filePath == null) {
      _loadDocument();
    } else {
      _initializePdfControllerWithPath(widget.filePath!);
      _isLoading = false;
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
      // Use the filePath provided by the document model (e.g., from your JSON)
      final String assetPath = widget.document.filePath;
      debugPrint('Loading PDF from: $assetPath');
      final ByteData bytes = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();

      // Ensure the directory exists
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Create a unique file name using the document id
      final String fileName = '${widget.document.id}.pdf';
      final String filePath = '${dir.path}${Platform.pathSeparator}$fileName';
      final file = File(filePath);

      // Write data to the file
      await file.writeAsBytes(bytes.buffer.asUint8List());
      debugPrint('Successfully wrote PDF to: ${file.path}');

      // Initialize the PDF controller
      _initializePdfControllerWithPath(file.path);

      setState(() {
        _pdfPath = file.path;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.document.title,
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
        actions: [
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
            PdfViewPinch(
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