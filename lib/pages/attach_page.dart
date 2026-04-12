import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/skeleton/attach_picker.dart';
import 'package:contrapp/skeleton/annex_editor.dart';

class AttachPage extends StatelessWidget {
  const AttachPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useTwoColumns = width >= 1400;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: useTwoColumns
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildScrollablePanel(
                              child: const AnnexEditor(),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _buildScrollablePanel(
                              child: _buildImagesPanel(),
                            ),
                          ),
                        ],
                      )
                    : _buildScrollablePanel(
                        child: Column(
                          children: [
                            const AnnexEditor(),
                            const SizedBox(height: 10),
                            _buildImagesPanel(),
                          ],
                        ),
                      ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TravelButton(
                    color: Colors.deepPurple,
                    icon: Icons.navigate_before,
                    label: 'Précédent',
                    link: '/calendar',
                    height: 100,
                    width: 500,
                    roundedBorder: 50,
                    textSize: 30,
                    scaleWidthFactor: 2,
                  ),
                  TravelButton(
                    color: Colors.green,
                    icon: Icons.navigate_next,
                    label: 'Suivant',
                    link: '/recap',
                    height: 100,
                    width: 500,
                    roundedBorder: 50,
                    textSize: 30,
                    scaleWidthFactor: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollablePanel({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: child,
      ),
    );
  }

  Widget _buildImagesPanel() {
    return Column(
      children: const [
        SizedBox(height: 18),
        AttachPicker(),
      ],
    );
  }
}
