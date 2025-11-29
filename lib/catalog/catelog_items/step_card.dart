import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// StepCard için JSON şeması
final _stepCardSchema = S.object(
  description: 'Tarif adımını gösteren kart',
  properties: {
    'stepNumber': S.integer(description: 'Adım numarası (1, 2, 3...)'),
    'instruction': S.string(description: 'Adımın detaylı açıklaması'),
    'tip': S.string(description: 'Opsiyonel ipucu veya dikkat edilecek nokta'),
    'duration': S.string(description: 'Bu adımın tahmini süresi'),
  },
  required: ['stepNumber', 'instruction'],
);

/// StepCard CatalogItem tanımı
final stepCardItem = CatalogItem(
  name: 'StepCard',
  dataSchema: _stepCardSchema,
  widgetBuilder: (itemContext) {
    final json = itemContext.data as Map<String, Object?>;
    final stepNumber = (json['stepNumber'] as num?)?.toInt() ?? 1;
    final instruction = json['instruction'] as String? ?? '';
    final tip = json['tip'] as String?;
    final duration = json['duration'] as String?;

    return _StepCardWidget(
      stepNumber: stepNumber,
      instruction: instruction,
      tip: tip,
      duration: duration,
    );
  },
);

/// StepCard StatefulWidget (tamamlandı işaretleme için)
class _StepCardWidget extends StatefulWidget {
  final int stepNumber;
  final String instruction;
  final String? tip;
  final String? duration;

  const _StepCardWidget({
    required this.stepNumber,
    required this.instruction,
    this.tip,
    this.duration,
  });

  @override
  State<_StepCardWidget> createState() => _StepCardWidgetState();
}

class _StepCardWidgetState extends State<_StepCardWidget> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Card(
        elevation: _isCompleted ? 1 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: _isCompleted
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _isCompleted = !_isCompleted;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adım numarası / Tamamlandı ikonu
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: _isCompleted
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 24,
                          )
                        : Text(
                            '${widget.stepNumber}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // İçerik
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Adım başlığı ve süre
                      Row(
                        children: [
                          Text(
                            'Adım ${widget.stepNumber}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isCompleted
                                      ? Theme.of(context).colorScheme.outline
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          if (widget.duration != null) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.duration!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Talimat
                      Text(
                        widget.instruction,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: _isCompleted
                              ? Theme.of(context).colorScheme.outline
                              : Theme.of(context).colorScheme.onSurface,
                          decoration: _isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      // İpucu (varsa)
                      if (widget.tip != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.tip!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.amber.shade900,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
