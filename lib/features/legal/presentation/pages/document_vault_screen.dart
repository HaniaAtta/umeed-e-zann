// lib/modules/legal/screens/document_vault_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../viewmodels/legal_provider.dart';
import '../../../../data/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  
  final StorageService _storageService = StorageService();
  
  @override
  void initState() {
    super.initState();
    // Load documents from Firebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LegalProvider>(context, listen: false);
      provider.loadUserDocuments();
    });
  }

  // Mock data for user's documents (fallback if no Firebase data)
  final List<Map<String, dynamic>> mockDocuments = [
  {
    'name': 'Marriage Certificate',
    'date': '12 Jan 2023',
    'type': 'PDF',
    'icon': Icons.description_rounded,
    'color': AppColors.accentPurple,
    'size': '2.4 MB',
  },
  {
    'name': 'Property Deed',
    'date': '05 Aug 2024',
    'type': 'DOCX',
    'icon': Icons.home_work_rounded,
    'color': AppColors.mediumPurple,
    'size': '1.8 MB',
  },
  {
    'name': 'ID Card Copy',
    'date': '10 Mar 2022',
    'type': 'JPEG',
    'icon': Icons.badge_rounded,
    'color': AppColors.accentPink,
    'size': '856 KB',
  },
  {
    'name': 'Will & Testament',
    'date': '20 Nov 2023',
    'type': 'PDF',
    'icon': Icons.gavel_rounded,
    'color': AppColors.primaryDark,
    'size': '3.1 MB',
  },
  {
    'name': 'Divorce Papers',
    'date': '15 Sep 2024',
    'type': 'PDF',
    'icon': Icons.description_rounded,
    'color': AppColors.lightPink,
    'size': '1.2 MB',
  },
];

  Future<void> _uploadDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.loginToUpload),
          backgroundColor: AppColors.dangerColor,
        ),
      );
      return;
    }

    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final fileExtension = fileName.split('.').last.toLowerCase();

      // Determine document type
      String docType = 'PDF';

      if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
        docType = 'IMAGE';
      } else if (['doc', 'docx'].contains(fileExtension)) {
        docType = 'DOCX';
      }

      // Upload to Firebase Storage
      final fileUrl = await _storageService.uploadDocument(file, fileName);
      
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.uploadingDoc),
          duration: Duration(seconds: 2),
        ),
      );

      // Save document metadata to Firestore
      final provider = Provider.of<LegalProvider>(context, listen: false);
      final documentId = await provider.saveDocument(
        title: fileName.split('.').first,
        type: docType,
        fileUrl: fileUrl,
        description: 'Uploaded document',
      );

      if (!mounted) return;
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (documentId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.docUploadSuccess),
              backgroundColor: AppColors.successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.docUploadFailed}: ${provider.error}'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading document: $e'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
  }

  String _formatTimestamp(BuildContext context, Timestamp? timestamp) {
    if (timestamp == null) return AppLocalizations.of(context)!.unknownDate;
    final date = timestamp.toDate();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData _getDocumentIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'IMAGE':
        return Icons.image_rounded;
      case 'DOCX':
        return Icons.description_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getDocumentColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'IMAGE':
        return AppColors.accentPink;
      case 'DOCX':
        return AppColors.mediumPurple;
      default:
        return AppColors.accentPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LegalProvider>(context);
    final documents = provider.userDocuments;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: provider.isLoading && documents.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(context.responsive(8)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryDark, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(context.responsive(8)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.search_rounded, color: AppColors.primaryDark, size: 20),
                ),
                onPressed: () {},
              ),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 24, bottom: 16, right: 24),
              title: Text(
                AppLocalizations.of(context)!.documentVault,
                style: AppTextStyles.heading2(context).copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // Upload Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
              child: Container(
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentPurple, AppColors.mediumPurple],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: Offset(context.responsive(0), context.responsive(10)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _uploadDocument,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: EdgeInsets.all(context.responsive(24)),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.cloud_upload_rounded,
                              color: AppColors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.uploadDocument,
                                  style: AppTextStyles.heading4(context).copyWith(
                                    color: AppColors.white,
                                    fontSize: context.responsive(20),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.secureStorageDesc,
                                  style: AppTextStyles.bodyMedium1(context).copyWith(
                                    color: AppColors.white.withValues(alpha: 0.9),
                                    fontSize: 13,
                                    
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Documents Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourDocuments,
                    style: AppTextStyles.heading3(context).copyWith(
                      fontSize: context.responsive(22),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(12),
                      vertical: context.responsive(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.responsive(12)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.filesCount(documents.length),
                      style: AppTextStyles.bodySmall1(context).copyWith(
                        color: AppColors.accentPurple,
                        fontSize: context.responsive(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(16))),

          // Documents List
          documents.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(context.responsive(32)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: context.responsive(64),
                            color: AppColors.grey,
                          ),
                          SizedBox(height: context.responsive(16)),
                          Text(
                            AppLocalizations.of(context)!.noDocumentsYet,
                            style: AppTextStyles.heading3(context).copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(height: context.responsive(8)),
                          Text(
                            AppLocalizations.of(context)!.uploadFirstDoc,
                            style: AppTextStyles.bodyMedium1(context).copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doc = documents[index];
                        return _buildDocumentCard(context, doc, index == documents.length - 1);
                      },
                      childCount: documents.length,
                    ),
                  ),
                ),

          SliverToBoxAdapter(child: SizedBox(height: context.responsive(32))),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, Map<String, dynamic> doc, bool isLast) {
    final docType = doc['type'] as String? ?? 'PDF';
    final docColor = _getDocumentColor(docType);
    final docIcon = _getDocumentIcon(docType);
    final title = doc['title'] as String? ?? 'Untitled Document';
    final uploadedAt = doc['uploadedAt'] as Timestamp?;
    final fileUrl = doc['fileUrl'] as String?;
    
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : context.responsive(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(20)),
        boxShadow: [
          BoxShadow(
            color: docColor.withValues(alpha: 0.1),
            blurRadius: context.responsive(15),
            offset: Offset(0, context.responsive(5)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // View document - open URL in browser
            if (fileUrl != null) {
              final uri = Uri.parse(fileUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not open document URL'),
                      backgroundColor: AppColors.accentPink,
                    ),
                  );
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(context.responsive(20)),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(20)),
            child: Row(
              children: [
                Container(
                  width: context.responsive(56),
                  height: context.responsive(56),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        docColor,
                        docColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(context.responsive(16)),
                  ),
                  child: Icon(
                    docIcon,
                    color: AppColors.white,
                    size: context.responsive(28),
                  ),
                ),
                SizedBox(width: context.responsive(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          fontSize: context.responsive(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: context.responsive(6)),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: docColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              docType,
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: docColor,
                              ),
                            ),
                          ),
                          if (uploadedAt != null) ...[
                            SizedBox(width: 8),
                            Text(
                              '• ${_formatTimestamp(context, uploadedAt)}',
                              style: AppTextStyles.bodyMedium1(context).copyWith(
                                fontSize: 12,
                                color: AppColors.primaryDark.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.primaryDark.withValues(alpha: 0.4),
                    size: 20,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.view),
                      onTap: () {
                        // View document
                      },
                    ),
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.delete),
                      onTap: () async {
                        final documentId = doc['id'] as String?;
                        if (documentId != null) {
                          final provider = Provider.of<LegalProvider>(context, listen: false);
                          await provider.deleteDocument(documentId);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
