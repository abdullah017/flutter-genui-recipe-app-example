import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// IngredientList için JSON şeması
final _ingredientListSchema = S.object(
  description: 'Tarif malzemelerinin listesi',
  properties: {
    'ingredients': S.list(
      description: 'Malzeme listesi',
      items: S.object(
        properties: {
          'name': S.string(description: 'Malzeme adı (örn: tavuk but)'),
          'amount': S.string(description: 'Miktar (örn: 500)'),
          'unit': S.string(description: 'Birim (örn: gram, adet, su bardağı)'),
        },
        required: ['name', 'amount', 'unit'],
      ),
    ),
    'servings': S.integer(description: 'Kaç kişilik tarif'),
  },
  required: ['ingredients'],
);

/// IngredientList CatalogItem tanımı
final ingredientListItem = CatalogItem(
  name: 'IngredientList',
  dataSchema: _ingredientListSchema,
  widgetBuilder: (itemContext) {
    final context = itemContext.buildContext;
    final json = itemContext.data as Map<String, Object?>;
    final ingredientsData = json['ingredients'] as List<Object?>? ?? [];
    final servings = (json['servings'] as num?)?.toInt() ?? 4;

    final ingredients = ingredientsData.map((item) {
      final map = item as Map<String, Object?>;
      return _Ingredient(
        name: map['name'] as String? ?? '',
        amount: map['amount'] as String? ?? '',
        unit: map['unit'] as String? ?? '',
      );
    }).toList();

    return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Malzemeler',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$servings kişilik',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Malzeme listesi
                  ...ingredients.map(
                    (ingredient) => _IngredientRow(ingredient: ingredient),
                  ),
                ],
              ),
            ),
          ),
    );
  },
);

/// Malzeme modeli
class _Ingredient {
  final String name;
  final String amount;
  final String unit;

  const _Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });
}

/// Tek bir malzeme satırı
class _IngredientRow extends StatefulWidget {
  final _Ingredient ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  State<_IngredientRow> createState() => _IngredientRowState();
}

class _IngredientRowState extends State<_IngredientRow> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isChecked
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  color: _isChecked
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: _isChecked
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Malzeme adı
              Expanded(
                child: Text(
                  widget.ingredient.name,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: _isChecked ? TextDecoration.lineThrough : null,
                    color: _isChecked
                        ? Theme.of(context).colorScheme.outline
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Miktar
              Text(
                '${widget.ingredient.amount} ${widget.ingredient.unit}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _isChecked
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
