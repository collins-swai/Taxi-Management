import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_system/presentation/blocs/auth_bloc.dart';
import '../blocs/car_bloc.dart';
import '../../data/models/car_model.dart';

class CarUpdatePage extends StatefulWidget {
  final Car car;

  CarUpdatePage({required this.car});

  @override
  _CarUpdatePageState createState() => _CarUpdatePageState();
}

class _CarUpdatePageState extends State<CarUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController modelController;
  late TextEditingController yearController;
  late TextEditingController vinController;
  late TextEditingController colorController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.car.carName);
    modelController = TextEditingController(text: widget.car.model);
    yearController = TextEditingController(text: widget.car.year.toString());
    vinController = TextEditingController(text: widget.car.vin);
    colorController = TextEditingController(text: widget.car.color);
    priceController = TextEditingController(text: widget.car.price.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    modelController.dispose();
    yearController.dispose();
    vinController.dispose();
    colorController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _updateCar() {
    if (_formKey.currentState!.validate()) {
      final updatedCar = Car(
        id: widget.car.id,
        carName: nameController.text,
        model: modelController.text,
        year: int.parse(yearController.text),
        vin: vinController.text,
        color: colorController.text,
        price: double.parse(priceController.text),
        availabilityStatus: widget.car.availabilityStatus,
      );

      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess && authState.token != null) {
        final token = authState.token!;

        context.read<CarBloc>().add(UpdateCar(updatedCar, token));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Car Updated Successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to update. Token missing.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Car Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: screenWidth > 600 ? 500 : screenWidth * 0.9, // Responsive width
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ..._buildTextFields(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateCar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Update Car',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  List<Widget> _buildTextFields() {
    return [
      _buildTextField(nameController, 'Car Name', Icons.drive_eta),
      const SizedBox(height: 16),
      _buildTextField(modelController, 'Model', Icons.directions_car),
      const SizedBox(height: 16),
      _buildTextField(yearController, 'Year', Icons.calendar_today,
          keyboardType: TextInputType.number),
      const SizedBox(height: 16),
      _buildTextField(vinController, 'VIN', Icons.confirmation_number),
      const SizedBox(height: 16),
      _buildTextField(colorController, 'Color', Icons.color_lens),
      const SizedBox(height: 16),
      _buildTextField(priceController, 'Price', Icons.attach_money,
          keyboardType: TextInputType.number),
    ];
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }
}
