import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_system/presentation/pages/car_listing.dart';
import '../blocs/car_bloc.dart';
import '../../data/models/car_model.dart';
import '../blocs/auth_bloc.dart'; // Import AuthBloc for token access

class CarCreatePage extends StatelessWidget {
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  CarCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Car'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarCreated) {
            _clearInputs();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CarListPage()),
            );
          } else if (state is CarError) {
            _showErrorDialog(context, state.message);
          }
        },
        child: BlocBuilder<CarBloc, CarState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Car Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: carNameController,
                        labelText: 'Car Name',
                        icon: Icons.drive_eta,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: modelController,
                        labelText: 'Model',
                        icon: Icons.model_training,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: yearController,
                        labelText: 'Year',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: vinController,
                        labelText: 'VIN',
                        icon: Icons.card_membership,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: colorController,
                        labelText: 'Color',
                        icon: Icons.color_lens,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: priceController,
                        labelText: 'Price',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 30),
                      if (state
                          is CarLoading)
                        Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            shadowColor: Colors.black38,
                            elevation: 6,
                          ),
                          onPressed: () {
                            if (_validateInputs()) {
                              final token = (context.read<AuthBloc>().state
                                      is Authenticated)
                                  ? (context.read<AuthBloc>().state
                                          as Authenticated)
                                      .token
                                  : '';

                              final car = Car(
                                id: '',
                                carName: carNameController.text,
                                model: modelController.text,
                                year: int.tryParse(yearController.text) ?? 0,
                                vin: vinController.text,
                                color: colorController.text,
                                price: double.tryParse(priceController.text) ??
                                    0.0,
                                availabilityStatus: true,
                              );

                              context
                                  .read<CarBloc>()
                                  .add(CreateCar(car, token));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Car has been added successfully!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CarListPage()),
                              );
                            } else {
                              _showErrorDialog(
                                  context, 'Please fill all fields correctly.');
                            }
                          },
                          child: const Text(
                            'Create',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.blue.withOpacity(0.05),
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87),
    );
  }

  bool _validateInputs() {
    return carNameController.text.isNotEmpty &&
        modelController.text.isNotEmpty &&
        yearController.text.isNotEmpty &&
        vinController.text.isNotEmpty &&
        colorController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
  }

  void _clearInputs() {
    carNameController.clear();
    modelController.clear();
    yearController.clear();
    vinController.clear();
    colorController.clear();
    priceController.clear();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
