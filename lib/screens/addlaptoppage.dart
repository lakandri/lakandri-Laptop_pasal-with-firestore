import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddLaptopPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final CollectionReference laptopsRef =
      FirebaseFirestore.instance.collection('laptops');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Laptop')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Laptop Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add a new laptop document to Firestore
                await laptopsRef.add({
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'description': descriptionController.text,
                  'imageUrl': imageUrlController.text,
                });

                // Clear the input fields
                nameController.clear();
                priceController.clear();
                descriptionController.clear();
                imageUrlController.clear();

                // Show success message or navigate back
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Laptop added successfully!')),
                );

                // Optionally, navigate back to the store page
                Navigator.pop(context);
              },
              child: const Text('Add Laptop'),
            ),
          ],
        ),
      ),
    );
  }
}
