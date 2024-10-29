class Car {
  final String id; // Should remain String since ID might be a number in string format
  final String carName;
  final String model;
  final double price; // Should be double for price
  final bool availabilityStatus;
  final int year; // Assuming year is integer
  final String vin;
  final String color;

  Car({
    required this.id,
    required this.carName,
    required this.model,
    required this.price,
    required this.availabilityStatus,
    required this.year,
    required this.vin,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'car_name': carName,
      'model': model,
      'availability_status': availabilityStatus ? 1 : 0,
      'year': year,
      'vin': vin,
      'color': color,
      'price': price,
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'].toString(),
      carName: json['car_name'] as String,
      model: json['model'] as String,
      price: double.parse(json['price']),
      availabilityStatus: json['availability_status'] == 1,
      year: int.parse(json['year']),
      vin: json['vin'] as String,
      color: json['color'] as String,
    );
  }
}
