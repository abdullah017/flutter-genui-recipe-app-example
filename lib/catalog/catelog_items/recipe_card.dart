import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// RecipeCard için JSON şeması
/// AI bu şemaya göre veri üretecek
final _recipeCardSchema = S.object(
  description: 'Bir yemek tarifinin özet bilgilerini gösteren kart',
  properties: {
    'title': S.string(
      description: 'Tarifin adı (örn: Fırında Patatesli Tavuk)',
    ),
    'duration': S.string(
      description: 'Toplam hazırlık ve pişirme süresi (örn: 45 dakika)',
    ),
    'difficulty': S.string(
      description: 'Zorluk seviyesi: Kolay, Orta veya Zor',
      enumValues: ['Kolay', 'Orta', 'Zor'],
    ),
    'imageDescription': S.string(
      description: 'Yemeğin görsel açıklaması (emoji ile)',
    ),
  },
  required: ['title', 'duration', 'difficulty'],
);

/// RecipeCard CatalogItem tanımı
final recipeCardItem = CatalogItem(
  name: 'RecipeCard',
  dataSchema: _recipeCardSchema,
  widgetBuilder: (itemContext) {
    final context = itemContext.buildContext;
    final json = itemContext.data as Map<String, Object?>;
    final title = json['title'] as String? ?? 'Tarif';
    final duration = json['duration'] as String? ?? '';
    final difficulty = json['difficulty'] as String? ?? 'Orta';
    final imageDescription = json['imageDescription'] as String? ?? '🍽️';

    // Zorluk seviyesine göre renk
    Color difficultyColor;
    switch (difficulty) {
      case 'Kolay':
        difficultyColor = Colors.green;
        break;
      case 'Zor':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.orange;
    }

    return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Üst kısım - Görsel alanı
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      imageDescription,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),

                // Alt kısım - Bilgiler
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Süre ve zorluk
                      Row(
                        children: [
                          // Süre
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  duration,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Zorluk
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: difficultyColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              difficulty,
                              style: TextStyle(
                                color: difficultyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  },
);
