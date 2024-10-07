import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_pasal/screens/admin/admin.dart';

class LaptopStorePage extends StatelessWidget {
  final CollectionReference laptopsRef =
      FirebaseFirestore.instance.collection('laptoppasal');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Laptop Pasal",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2937), Color(0xFF3B3B3B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLaptopPage()),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu action
          },
        ),
        centerTitle: true, // Centered title
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: laptopsRef.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No laptops available'));
            }

            final laptopsData = snapshot.data!.docs;

            return GridView.builder(
              physics: const BouncingScrollPhysics(), // Smooth scroll physics
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6, // Compact size for grid items
              ),
              itemCount: laptopsData.length,
              itemBuilder: (context, index) {
                final laptop = laptopsData[index];
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: LaptopCard(laptop: laptop),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Separate widget for Laptop Card with Animations
class LaptopCard extends StatefulWidget {
  final QueryDocumentSnapshot laptop;

  const LaptopCard({required this.laptop});

  @override
  _LaptopCardState createState() => _LaptopCardState();
}

class _LaptopCardState extends State<LaptopCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Card(
          elevation: 8,
          shadowColor: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              _showDetailsDialog(context, widget.laptop);
            },
            splashColor: Colors.blueAccent.withAlpha(30),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Stack(
                      children: [
                        Hero(
                          tag: widget.laptop['imgurl'],
                          child: Image.network(
                            widget.laptop['imgurl'],
                            fit: BoxFit.fitHeight,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 80),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.laptop['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Rs ${widget.laptop['Price']}",
                          style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.laptop['Description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Buy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _buyLaptop(context, widget.laptop);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showDetailsDialog(context, widget.laptop);
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

  void _buyLaptop(BuildContext context, DocumentSnapshot laptop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bought: ${laptop['Name']}")),
    );
  }

  void _showDetailsDialog(BuildContext context, DocumentSnapshot laptop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(laptop['Name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Hero(
                  tag: laptop['imgurl'],
                  child: Image.network(laptop['imgurl'],
                      height: 150, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: Rs ${laptop['Price']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green[600]),
                ),
                const SizedBox(height: 5),
                Text(laptop['Description']),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
