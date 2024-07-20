// import 'package:flutter/material.dart';
// import 'category_add.dart';
// import 'category_data.dart';

// class CategoryList extends StatefulWidget {
//   const CategoryList({super.key});

//   @override
//   State<CategoryList> createState() => _CategoryListState();
// }

// class _CategoryListState extends State<CategoryList> {
//   // get list

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.cyan,
//                 Colors.cyan.withOpacity(0.5),
//                 Colors.blue.withOpacity(0.5),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Danh sách danh mục",
//           style: const TextStyle(fontSize: 26, color: Colors.black),
//         ),
//       ),
//       body: Center(child: CategoryBuilder()),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context)
//               .push(
//                 MaterialPageRoute(
//                   builder: (_) => const CategoryAdd(),
//                   fullscreenDialog: true,
//                 ),
//               )
//               .then((_) => setState(() {}));
//         },
//         tooltip: 'Add New',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'category_add.dart';
import 'category_data.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // get list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.cyanAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Danh sách danh mục",
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ),
      ),
      body: const Center(child: CategoryBuilder()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const CategoryAdd(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
