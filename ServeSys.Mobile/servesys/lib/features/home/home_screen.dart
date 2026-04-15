import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _buildBody());
  }
}

Widget _buildBody() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context, index) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("T 01"),
                    SizedBox(width: 16,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Trống"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.people, size: 16),
                  SizedBox(width: 4),
                  Text("4 Chỗ"),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
