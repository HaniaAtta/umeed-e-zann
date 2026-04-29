import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../contents/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';
import '../widgets/consultation_history_card.dart';
import '../widgets/doctor_booking_dialog.dart';
import '../providers/telehealth_provider.dart';
import '../../domain/entities/doctor.dart' as domain;

/// Tele-Health Screen
/// Connects women with doctors, prioritizing privacy and ease of access
/// Uses AppColors.background as base
class TeleHealthScreen extends StatefulWidget {
  const TeleHealthScreen({super.key});

  @override
  State<TeleHealthScreen> createState() => _TeleHealthScreenState();
}

class _TeleHealthScreenState extends State<TeleHealthScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isAnonymousMode = false;
  String selectedFilter = 'All'; // Filter: All, Gynecologist, Psychologist

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TeleHealthProvider>(context, listen: false);
      provider.loadDoctors();
      provider.loadUserAppointments();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Convert domain Doctor to presentation Doctor
  Doctor _domainToPresentation(domain.Doctor domainDoctor) {
    return Doctor(
      name: domainDoctor.name,
      specialty: domainDoctor.specialty,
      rating: domainDoctor.rating,
      imageUrl: domainDoctor.imageUrl ?? '',
      isChatAvailable: domainDoctor.isChatAvailable,
      isVideoAvailable: domainDoctor.isVideoAvailable,
    );
  }

  // Get doctors from provider or fallback to mock data
  List<Doctor> get _availableDoctors {
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);
    if (provider.doctors.isNotEmpty) {
      return provider.doctors.map(_domainToPresentation).toList();
    }
    // Fallback to mock data if Firestore is empty
    return DoctorsData.doctors;
  }

  // Get last consulted doctor (from appointments or first doctor)
  Doctor? get lastConsultedDoctor {
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);
    if (provider.appointments.isNotEmpty) {
      // In real app, would fetch doctor by ID
      return _availableDoctors.isNotEmpty ? _availableDoctors[0] : null;
    }
    return _availableDoctors.isNotEmpty ? _availableDoctors[0] : null;
  }

  List<Doctor> get filteredDoctors {
    var doctors = _availableDoctors;
    
    // Filter by specialty
    if (selectedFilter != 'All') {
      doctors = doctors.where((doctor) {
        return doctor.specialty == selectedFilter;
      }).toList();
    }
    
    // Filter by search query
    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      doctors = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query);
      }).toList();
    }
    
    return doctors;
  }

  void _handleReBook(Doctor doctor) {
    _handleBookAppointment(doctor);
  }

  void _handleViewProfile(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Responsive(context).radiusXL),
        ),
        title: Text(
          doctor.name,
          style: AppTextStyles.headingSmall(
            color: AppColors.primaryDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specialty: ${doctor.specialty}',
              style: AppTextStyles.bodyMedium(
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(height: Responsive(context).spacingM),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: Responsive(context).iconSize(20)),
                SizedBox(width: Responsive(context).spacingS),
                Text(
                  doctor.ratingString,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive(context).spacingM),
            if (doctor.isChatAvailable)
              Row(
                children: [
                  Icon(Icons.chat_bubble_rounded, color: AppColors.secondaryPurple, size: Responsive(context).iconSize(20)),
                  SizedBox(width: Responsive(context).spacingS),
                  Text(
                    'Chat Available',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            if (doctor.isVideoAvailable) ...[
              SizedBox(height: Responsive(context).spacingS),
              Row(
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.green, size: Responsive(context).iconSize(20)),
                  SizedBox(width: Responsive(context).spacingS),
                  Text(
                    'Video Call Available',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTextStyles.bodyMedium(
                color: AppColors.secondaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBookAppointment(Doctor doctor) {
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);
    
    // Find domain doctor by name or create one if not found
    domain.Doctor domainDoctor;
    try {
      domainDoctor = provider.doctors.firstWhere(
        (d) => d.name == doctor.name,
      );
    } catch (e) {
      // If not found in Firestore, create a temporary one from mock data
      domainDoctor = domain.Doctor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: doctor.name,
        specialty: doctor.specialty,
        rating: doctor.rating,
        imageUrl: doctor.imageUrl,
        isChatAvailable: doctor.isChatAvailable,
        isVideoAvailable: doctor.isVideoAvailable,
      );
    }

    showDialog(
      context: context,
      builder: (context) => DoctorBookingDialog(doctor: domainDoctor),
    );
  }
  
  void _handleChat(Doctor doctor) async {
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);
    
    domain.Doctor domainDoctor;
    try {
      domainDoctor = provider.doctors.firstWhere(
        (d) => d.name == doctor.name,
      );
    } catch (e) {
      domainDoctor = domain.Doctor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: doctor.name,
        specialty: doctor.specialty,
        rating: doctor.rating,
        imageUrl: doctor.imageUrl,
        isChatAvailable: doctor.isChatAvailable,
        isVideoAvailable: doctor.isVideoAvailable,
      );
    }
    
    // Book immediate chat appointment
    final now = DateTime.now();
    try {
      await provider.bookAppointment(domainDoctor.id, now, 'chat');
      await provider.loadUserAppointments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chat session started with ${doctor.name}'),
            backgroundColor: AppColors.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
        // In real app, would navigate to chat screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting chat: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  void _handleVideoCall(Doctor doctor) async {
    final provider = Provider.of<TeleHealthProvider>(context, listen: false);
    
    domain.Doctor domainDoctor;
    try {
      domainDoctor = provider.doctors.firstWhere(
        (d) => d.name == doctor.name,
      );
    } catch (e) {
      domainDoctor = domain.Doctor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: doctor.name,
        specialty: doctor.specialty,
        rating: doctor.rating,
        imageUrl: doctor.imageUrl,
        isChatAvailable: doctor.isChatAvailable,
        isVideoAvailable: doctor.isVideoAvailable,
      );
    }
    
    // Book immediate video call
    final now = DateTime.now();
    try {
      await provider.bookAppointment(domainDoctor.id, now, 'video');
      await provider.loadUserAppointments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video call started with ${doctor.name}'),
            backgroundColor: AppColors.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
        // In real app, would navigate to video call screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting video call: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<TeleHealthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'wellness'),
      appBar: const CustomAppBar(
        title: 'Tele-Health',
        showLogo: true,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Top Section: Privacy & Search
          Container(
            padding: responsive.screenPadding.copyWith(
              top: responsive.spacingXL,
              bottom: responsive.spacingL,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.05),
                  blurRadius: responsive.spacingS,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Row 1: Search Bar
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchDoctors,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.grey,
                      size: responsive.iconSize(24),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: AppColors.grey,
                              size: responsive.iconSize(20),
                            ),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusL),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusL),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(responsive.radiusL),
                      borderSide: BorderSide(
                        color: AppColors.secondaryPurple,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.spacingL,
                      vertical: responsive.spacingM,
                    ),
                  ),
                ),
                
                SizedBox(height: responsive.spacingL),
                
                // Filter Chips: All, Gynecologist, Psychologist
                SizedBox(
                  height: responsive.size(45),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final filters = ['All', 'Gynecologist', 'Psychologist'];
                      final filter = filters[index];
                      final isSelected = selectedFilter == filter;
                      
                      return Padding(
                        padding: EdgeInsets.only(right: responsive.spacingM),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            borderRadius: BorderRadius.circular(responsive.radiusRound),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.spacingL,
                                vertical: responsive.spacingM,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.secondaryPurple
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(responsive.radiusRound),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.secondaryPurple
                                      : AppColors.lightGrey,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.secondaryPurple.withValues(alpha: 0.3),
                                          blurRadius: responsive.spacingS,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  filter,
                                  style: AppTextStyles.bodyMedium(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.primaryDark,
                                  ).copyWith(
                                    fontSize: responsive.fontSize(14),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: responsive.spacingL),
                
                // Row 2: Safety Toggle - Anonymous Mode
                Container(
                  padding: responsive.paddingM,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(responsive.radiusM),
                    border: Border.all(
                      color: AppColors.lightGrey,
                      width: 1,
                    ),
                  ),
                  child: SwitchListTile(
                    value: isAnonymousMode,
                    onChanged: (value) {
                      setState(() {
                        isAnonymousMode = value;
                      });
                    },
                    title: Text(
                      'Anonymous Mode',
                      style: AppTextStyles.bodyLarge(
                        color: AppColors.primaryDark,
                      ).copyWith(
                        fontSize: responsive.fontSize(15),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Hide my identity during consultation',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.primaryDark.withValues(alpha: 0.7),
                      ).copyWith(
                        fontSize: responsive.fontSize(13),
                      ),
                    ),
                    activeThumbColor: AppColors.secondaryPurple,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          
          // Middle Section: Consultation History
          if (lastConsultedDoctor != null)
            Container(
              padding: responsive.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Consultations',
                    style: AppTextStyles.headingSmall(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: responsive.spacingM),
                  ConsultationHistoryCard(
                    doctor: lastConsultedDoctor!,
                    onReBook: () => _handleReBook(lastConsultedDoctor!),
                  ),
                ],
              ),
            ),
          
          // Main Section: Doctor List
          Expanded(
            child: Container(
              padding: responsive.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Doctors',
                    style: AppTextStyles.headingSmall(
                      color: AppColors.primaryDark,
                    ).copyWith(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: responsive.spacingM),
                  Expanded(
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondaryPurple,
                            ),
                          )
                        : filteredDoctors.isEmpty
                            ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: responsive.iconSize(64),
                                  color: AppColors.grey,
                                ),
                                SizedBox(height: responsive.spacingM),
                                Text(
                                  'No doctors found',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                                  ).copyWith(
                                    fontSize: responsive.fontSize(16),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = filteredDoctors[index];
                              return DoctorCard(
                                doctor: doctor,
                                onViewProfile: () => _handleViewProfile(doctor),
                                onBookAppointment: () => _handleBookAppointment(doctor),
                                onChat: doctor.isChatAvailable
                                    ? () => _handleChat(doctor)
                                    : null,
                                onVideoCall: doctor.isVideoAvailable
                                    ? () => _handleVideoCall(doctor)
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
