import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/ChangeModeProvider.dart';
import '../../utils/AppStrings.dart';

/// Professional theme toggle widget with multiple display options
class ThemeToggleWidget extends StatelessWidget {
  /// Display style for the theme toggle
  final ThemeToggleStyle style;

  /// Whether to show labels for the theme modes
  final bool showLabels;

  /// Icon size for icon-based styles
  final double iconSize;

  /// Custom colors (optional)
  final Color? activeColor;
  final Color? inactiveColor;

  const ThemeToggleWidget({
    super.key,
    this.style = ThemeToggleStyle.iconButton,
    this.showLabels = false,
    this.iconSize = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        switch (style) {
          case ThemeToggleStyle.iconButton:
            return _buildIconButton(context, themeProvider);
          case ThemeToggleStyle.switch3Way:
            return _buildThreeWaySwitch(context, themeProvider);
          case ThemeToggleStyle.segmentedButton:
            return _buildSegmentedButton(context, themeProvider);
          case ThemeToggleStyle.dropdownButton:
            return _buildDropdownButton(context, themeProvider);
          case ThemeToggleStyle.toggleButtons:
            return _buildToggleButtons(context, themeProvider);
        }
      },
    );
  }

  /// Simple icon button that cycles through theme modes
  Widget _buildIconButton(BuildContext context, ThemeProvider themeProvider) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          themeProvider.themeIcon,
          key: ValueKey(themeProvider.themeMode),
          size: iconSize,
          color: activeColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
      tooltip: '${AppStrings.switchTo} ${themeProvider.themeModeDisplayName}',
      onPressed: () => themeProvider.cycleThemeMode(),
    );
  }

  /// Three-way toggle with system/light/dark options
  Widget _buildThreeWaySwitch(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            context,
            themeProvider,
            ThemeMode.system,
            Icons.brightness_auto,
            'System',
          ),
          _buildModeButton(
            context,
            themeProvider,
            ThemeMode.light,
            Icons.light_mode,
            'Light',
          ),
          _buildModeButton(
            context,
            themeProvider,
            ThemeMode.dark,
            Icons.dark_mode,
            'Dark',
          ),
        ],
      ),
    );
  }

  /// Material 3 segmented button
  Widget _buildSegmentedButton(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: showLabels ? const Text('System') : null,
          icon: const Icon(Icons.brightness_auto),
          tooltip: 'System Theme',
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: showLabels ? const Text('Light') : null,
          icon: const Icon(Icons.light_mode),
          tooltip: 'Light Theme',
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: showLabels ? const Text('Dark') : null,
          icon: const Icon(Icons.dark_mode),
          tooltip: 'Dark Theme',
        ),
      ],
      selected: {themeProvider.themeMode},
      onSelectionChanged: (Set<ThemeMode> selection) {
        themeProvider.setThemeMode(selection.first);
      },
    );
  }

  /// Dropdown button for compact spaces
  Widget _buildDropdownButton(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return DropdownButton<ThemeMode>(
      value: themeProvider.themeMode,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(),
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.brightness_auto, size: iconSize),
              if (showLabels) ...[
                const SizedBox(width: 8),
                const Text('System'),
              ],
            ],
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.light_mode, size: iconSize),
              if (showLabels) ...[
                const SizedBox(width: 8),
                const Text('Light'),
              ],
            ],
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dark_mode, size: iconSize),
              if (showLabels) ...[const SizedBox(width: 8), const Text('Dark')],
            ],
          ),
        ),
      ],
      onChanged: (ThemeMode? mode) {
        if (mode != null) {
          themeProvider.setThemeMode(mode);
        }
      },
    );
  }

  /// Toggle buttons for horizontal layout
  Widget _buildToggleButtons(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return ToggleButtons(
      isSelected: [
        themeProvider.themeMode == ThemeMode.system,
        themeProvider.themeMode == ThemeMode.light,
        themeProvider.themeMode == ThemeMode.dark,
      ],
      onPressed: (int index) {
        final modes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
        themeProvider.setThemeMode(modes[index]);
      },
      children: [
        Tooltip(
          message: 'System Theme',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.brightness_auto, size: iconSize),
          ),
        ),
        Tooltip(
          message: 'Light Theme',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.light_mode, size: iconSize),
          ),
        ),
        Tooltip(
          message: 'Dark Theme',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.dark_mode, size: iconSize),
          ),
        ),
      ],
    );
  }

  /// Helper method to build mode buttons for three-way switch
  Widget _buildModeButton(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? activeColor ?? theme.colorScheme.primary
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => themeProvider.setThemeMode(mode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Available styles for the theme toggle widget
enum ThemeToggleStyle {
  /// Simple icon button that cycles through modes
  iconButton,

  /// Three-way horizontal toggle
  switch3Way,

  /// Material 3 segmented button
  segmentedButton,

  /// Dropdown button for compact spaces
  dropdownButton,

  /// Traditional toggle buttons
  toggleButtons,
}

/// Extension to add theme toggle to AppBar
extension ThemeToggleAppBar on AppBar {
  /// Creates an AppBar action for theme toggle
  static Widget createAction({
    ThemeToggleStyle style = ThemeToggleStyle.iconButton,
    double iconSize = 24.0,
  }) {
    return ThemeToggleWidget(style: style, iconSize: iconSize);
  }
}
