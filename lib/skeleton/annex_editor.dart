import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/object/annex.dart';
import 'package:flutter/material.dart';

class AnnexEditor extends StatefulWidget {
  const AnnexEditor({super.key});

  @override
  State<AnnexEditor> createState() => _AnnexEditorState();
}

class _AnnexEditorState extends State<AnnexEditor> {
  @override
  Widget build(BuildContext context) {
    final widthFactor = MediaQuery.of(context).size.width / 1920;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 32, 10, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  key: const ValueKey('annex-title'),
                  value: contractAnnex.title,
                  label: 'Grand titre de l\'annexe',
                  hintText: 'Exemple: Remarques générales',
                  icon: Icons.title,
                  color: Colors.indigo,
                  onChanged: (value) {
                    contractAnnex.title = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                color: Colors.green,
                icon: Icons.add,
                label: 'Add',
                onPressed: () {
                  setState(() {
                    contractAnnex.addSubtitle();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (contractAnnex.subtitles.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Ajoutez un grand titre, des sous titres et des bullets-points en annexe.',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 22 * widthFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...contractAnnex.subtitles.asMap().entries.map((entry) {
            final subtitle = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: _AnnexSubtitleCard(
                key: ObjectKey(subtitle),
                subtitle: subtitle,
                index: entry.key,
                totalCount: contractAnnex.subtitles.length,
                onChanged: () => setState(() {}),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required MaterialColor color,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AnnexSubtitleCard extends StatelessWidget {
  const _AnnexSubtitleCard({
    required super.key,
    required this.subtitle,
    required this.index,
    required this.totalCount,
    required this.onChanged,
  });

  final AnnexSubtitle subtitle;
  final int index;
  final int totalCount;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final widthFactor = MediaQuery.of(context).size.width / 1920;

    return Container(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.blue[200] : Colors.blue[300],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 57, 126),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildReorderControls(
                  canMoveUp: index > 0,
                  canMoveDown: index < totalCount - 1,
                  moveUp: () {
                    contractAnnex.moveSubtitleUp(subtitle);
                    onChanged();
                  },
                  moveDown: () {
                    contractAnnex.moveSubtitleDown(subtitle);
                    onChanged();
                  },
                  enabledColor: Colors.white,
                  disabledColor: Colors.white38,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    key: ObjectKey(subtitle),
                    value: subtitle.title,
                    label: 'Sous-titre',
                    hintText: 'Exemple : Travaux exclus',
                    icon: Icons.subtitles,
                    color: Colors.indigo,
                    onChanged: (value) {
                      subtitle.title = value;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                _buildSmallActionButton(
                  color: Colors.green,
                  icon: Icons.add,
                  tooltip: 'Ajouter une remarque',
                  label: 'Add',
                  onPressed: () {
                    subtitle.addRemark();
                    onChanged();
                  },
                ),
                const SizedBox(width: 12),
                _buildDeleteButton(
                  tooltip: 'Supprimer ce sous-titre',
                  onPressed: () {
                    contractAnnex.removeSubtitle(subtitle);
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (subtitle.remarks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Ajoutez une ou plusieurs remarques sous ce sous-titre.',
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 18 * widthFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...subtitle.remarks.asMap().entries.map((entry) {
            final remark = entry.value;
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _AnnexRemarkTile(
                key: ObjectKey(remark),
                remark: remark,
                index: entry.key,
                totalCount: subtitle.remarks.length,
                subtitle: subtitle,
                onChanged: onChanged,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnnexRemarkTile extends StatelessWidget {
  const _AnnexRemarkTile({
    required super.key,
    required this.remark,
    required this.index,
    required this.totalCount,
    required this.subtitle,
    required this.onChanged,
  });

  final AnnexRemark remark;
  final int index;
  final int totalCount;
  final AnnexSubtitle subtitle;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReorderControls(
            canMoveUp: index > 0,
            canMoveDown: index < totalCount - 1,
            moveUp: () {
              subtitle.moveRemarkUp(remark);
              onChanged();
            },
            moveDown: () {
              subtitle.moveRemarkDown(remark);
              onChanged();
            },
            enabledColor: Colors.black,
            disabledColor: Colors.black26,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(
              key: ObjectKey(remark),
              value: remark.text,
              label: 'Remarque',
              hintText: 'Saisissez une remarque libre',
              icon: Icons.notes,
              color: Colors.blue,
              minLines: 1,
              maxLines: null,
              onChanged: (value) {
                remark.text = value;
              },
            ),
          ),
          const SizedBox(width: 12),
          _buildDeleteButton(
            tooltip: 'Supprimer cette remarque',
            onPressed: () {
              subtitle.removeRemark(remark);
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildTextField({
  required Key key,
  required String value,
  required String label,
  required String hintText,
  required IconData icon,
  required MaterialColor color,
  required ValueChanged<String> onChanged,
  int minLines = 1,
  int? maxLines = 1,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color[100]!.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextFormField(
      key: key,
      initialValue: value,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color[900],
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: color[900]),
        labelStyle: TextStyle(
          color: color[700],
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          color: color[700]!.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color[900]!,
            width: 3,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color[700]!,
            width: 2,
          ),
        ),
      ),
    ),
  );
}

Widget _buildReorderControls({
  required bool canMoveUp,
  required bool canMoveDown,
  required VoidCallback moveUp,
  required VoidCallback moveDown,
  required Color enabledColor,
  required Color disabledColor,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_up),
        color: canMoveUp ? enabledColor : disabledColor,
        onPressed: canMoveUp ? moveUp : null,
        constraints: const BoxConstraints(maxHeight: 30, maxWidth: 50),
      ),
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        color: canMoveDown ? enabledColor : disabledColor,
        onPressed: canMoveDown ? moveDown : null,
        constraints: const BoxConstraints(maxHeight: 30, maxWidth: 50),
      ),
    ],
  );
}

Widget _buildDeleteButton({
  required String tooltip,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(800),
      border: Border.all(
        color: Colors.red[900]!,
        width: 2,
      ),
      color: const Color.fromARGB(255, 255, 36, 0),
    ),
    child: IconButton(
      tooltip: tooltip,
      icon: const Icon(Icons.delete),
      color: Colors.white,
      onPressed: onPressed,
    ),
  );
}

Widget _buildSmallActionButton({
  required MaterialColor color,
  required IconData icon,
  required String tooltip,
  required String label,
  required VoidCallback onPressed,
}) {
  return Tooltip(
    message: tooltip,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 22),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
