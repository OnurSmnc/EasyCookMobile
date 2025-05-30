import 'package:easycook/core/data/models/allergenics/allergenic_response.dart';
import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:flutter/material.dart';

class IngredientSelectorDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<IngredientData> currentList,
    required List<IngredientData> availableIngredients,
    required Function(String) onAdd,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IngredientSelectorWidget(
          title: title,
          subtitle: subtitle,
          currentList: currentList,
          availableIngredients: availableIngredients,
          onAdd: onAdd,
        );
      },
    );
  }
}

class IngredientSelectorWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<IngredientData> currentList;
  final List<IngredientData> availableIngredients;
  final Function(String) onAdd;

  const IngredientSelectorWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.currentList,
    required this.availableIngredients,
    required this.onAdd,
  }) : super(key: key);

  @override
  _IngredientSelectorWidgetState createState() =>
      _IngredientSelectorWidgetState();
}

class _IngredientSelectorWidgetState extends State<IngredientSelectorWidget> {
  late TextEditingController _searchController;
  late List<IngredientData> filteredIngredients;
  late List<IngredientData> availableIngredients;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    availableIngredients = widget.availableIngredients
        .where((ingredient) => !widget.currentList.contains(ingredient))
        .toList();
    filteredIngredients = List.from(availableIngredients);
    _searchController.addListener(_filterIngredients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterIngredients() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredIngredients = availableIngredients
          .where((ingredient) => ingredient.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            // Arama kutusu
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Malzeme ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 16),

            // Sonuç sayısı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredIngredients.length} malzeme bulundu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (widget.currentList.isNotEmpty)
                  Text(
                    '${widget.currentList.length} öğe mevcut',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),

            // Malzeme listesi
            Expanded(
              child: filteredIngredients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'Arama kriterine uygun malzeme bulunamadı'
                                : 'Eklenecek malzeme kalmadı',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredIngredients.length,
                      itemBuilder: (context, index) {
                        IngredientData ingredient = filteredIngredients[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: Text(
                                ingredient.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              ingredient.name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.add_circle,
                              color: Colors.green[600],
                            ),
                            onTap: () {
                              widget.onAdd(ingredient.name);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Kapat'),
        ),
      ],
    );
  }
}
