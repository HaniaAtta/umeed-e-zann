import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../contents/colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class VerificationFormPage extends StatefulWidget {
  const VerificationFormPage({super.key});

  @override
  State<VerificationFormPage> createState() => _VerificationFormPageState();
}

class _VerificationFormPageState extends State<VerificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  final List<String> _uploadedDocuments = [];
  int _currentStep = 0;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Verification',
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              if (_validateStep(_currentStep)) {
                setState(() {
                  _currentStep++;
                });
              }
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          steps: [
            _buildPersonalInfoStep(responsive),
            _buildIdentityVerificationStep(responsive),
            _buildDocumentUploadStep(responsive),
          ],
        ),
      ),
    );
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        return _formKey.currentState!.validate();
      case 1:
        return true; // Add validation for identity verification
      case 2:
        return _uploadedDocuments.length >= 2;
      default:
        return false;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _uploadedDocuments.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification application submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Step _buildPersonalInfoStep(Responsive responsive) {
    return Step(
      title: const Text('Personal Information'),
      content: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
            ),
            validator: (value) => Validators.validateRequired(value, fieldName: 'First Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
            ),
            validator: (value) => Validators.validateRequired(value, fieldName: 'Last Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
            ),
            validator: (value) => Validators.validateRequired(value, fieldName: 'Address'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  validator: (value) => Validators.validateRequired(value, fieldName: 'City'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP Code',
                  ),
                  validator: (value) => Validators.validateRequired(value, fieldName: 'ZIP Code'),
                ),
              ),
            ],
          ),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildIdentityVerificationStep(Responsive responsive) {
    return Step(
      title: const Text('Identity Verification'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please provide your government-issued ID information',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'ID Type',
            ),
            items: ['Passport', 'Driver\'s License', 'National ID'].map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {},
            validator: (value) => Validators.validateRequired(value, fieldName: 'ID Type'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'ID Number',
            ),
            validator: (value) => Validators.validateRequired(value, fieldName: 'ID Number'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              hintText: 'MM/DD/YYYY',
            ),
            readOnly: true,
            onTap: () {
              // Show date picker
            },
            validator: (value) => Validators.validateRequired(value, fieldName: 'Date of Birth'),
          ),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildDocumentUploadStep(Responsive responsive) {
    return Step(
      title: const Text('Document Upload'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload required documents (Minimum 2 documents)',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          if (_uploadedDocuments.isEmpty)
            _buildUploadButton('Upload ID Document', () {
              setState(() {
                _uploadedDocuments.add('document_${_uploadedDocuments.length + 1}');
              });
            })
          else
            ..._uploadedDocuments.map((doc) => _buildDocumentItem(doc)),
          if (_uploadedDocuments.length < 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildUploadButton('Add Another Document', () {
                setState(() {
                  _uploadedDocuments.add('document_${_uploadedDocuments.length + 1}');
                });
              }),
            ),
        ],
      ),
      isActive: _currentStep >= 2,
      state: StepState.indexed,
    );
  }

  Widget _buildUploadButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryPurple, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, color: AppColors.primaryPurple),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String docName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: AppColors.primaryPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              docName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              setState(() {
                _uploadedDocuments.remove(docName);
              });
            },
          ),
        ],
      ),
    );
  }
}

