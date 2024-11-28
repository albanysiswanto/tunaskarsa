import 'package:flutter/material.dart';
import 'package:tunaskarsa/pages/dashboard_page.dart';
import 'package:tunaskarsa/service/user_service.dart';

class BiodataPage extends StatefulWidget {
  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String? _selectedRole;
  String? _selectedGrade;

  final List<String> roles = ['Student', 'Parent'];
  final List<String> grades = ['Sekolah Dasar', 'Sekolah Menengah Pertama', 'Sekolah Menengah Atas'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Complete Your Biodata",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Let's get to know you better",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  // First Name Field
                  _buildTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Last Name Field
                  _buildTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Role Dropdown
                  _buildDropdown(
                    label: "Role",
                    icon: Icons.school,
                    value: _selectedRole,
                    items: roles,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                        if (_selectedRole != 'Student') {
                          _selectedGrade = null; // Reset Grade if not Student
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Grade Dropdown (Only visible if Role is Student)
                  if (_selectedRole == 'Student')
                    _buildDropdown(
                      label: "Grade",
                      icon: Icons.grade,
                      value: _selectedGrade,
                      items: grades,
                      onChanged: (value) {
                        setState(() {
                          _selectedGrade = value;
                        });
                      },
                    ),
                  const Spacer(),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        if(_selectedRole == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a role.'))
                          );
                          return;
                        }
                        if(_selectedRole == 'Student' && _selectedGrade == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a grade'))
                          );
                          return;
                        }
                        try{
                          await UserService().saveBiodata(
                            firstName: _firstNameController.text.trim(), 
                            lastName: _lastNameController.text.trim(),
                            role: _selectedRole!,
                            grade: _selectedGrade == 'Student' ? _selectedGrade : null
                            );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Biodata save successfully'))
                          );

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fail saved biodata: $e'))
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "SAVE BIODATA",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController? controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
  required String label,
  required IconData icon,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    dropdownColor: Colors.white, // Warna dropdown saat terbuka
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    value: value,
    items: items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(color: Colors.black), // Warna teks dropdown saat terbuka
        ),
      );
    }).toList(),
    onChanged: onChanged,
    style: const TextStyle(color: Colors.white), // Warna teks setelah dipilih
    selectedItemBuilder: (BuildContext context) {
      return items.map<Widget>((item) {
        return Text(
          item,
          style: const TextStyle(color: Colors.white), // Teks tetap putih setelah dipilih
        );
      }).toList();
    },
  );
}

}