import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF365C96)),
      home: const NotesPage(),
    );
  }
}

class Note {
  Note(this.title, this.text);

  String title;
  String text;
  bool isImportant = false;
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];

  Future<void> _editNote([Note? note]) async {
    var title = note?.title ?? '';
    var text = note?.text ?? '';
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<Note>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Новая заметка' : 'Редактирование'),
        scrollable: true,
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: title,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Заголовок',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => title = value,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Введите заголовок'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: text,
                  minLines: 4,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Текст заметки',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) => text = value,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Введите текст заметки'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, Note(title.trim(), text.trim()));
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );

    if (!mounted || saved == null) return;

    setState(() {
      if (note == null) {
        _notes.add(saved);
      } else {
        note.title = saved.title;
        note.text = saved.text;
      }
    });
  }

  void _viewNote(Note note) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.title),
        scrollable: true,
        content: SizedBox(width: 420, child: SelectableText(note.text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: _notes.isEmpty
              ? const Center(child: Text('Добавь первую заметку'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                  itemCount: _notes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final note = _notes[index];

                    return NoteCard(
                      key: ObjectKey(note),
                      note: note,
                      onTap: () => _viewNote(note),
                      onDoubleTap: () => setState(() => note.isImportant = true),
                      onLongPress: () => _editNote(note),
                      onSwipeLeft: () => setState(() => _notes.remove(note)),
                      onSwipeRight: () =>
                          setState(() => note.isImportant = false),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editNote(),
        tooltip: 'Добавить заметку',
        icon: const Icon(Icons.add),
        label: const Text('Новая заметка'),
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  static const _swipeThreshold = 72.0;
  double _dragOffset = 0;

  void _resetDrag() => setState(() => _dragOffset = 0);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final isImportant = widget.note.isImportant;
    final foreground = isImportant
        ? const Color(0xFF674500)
        : colors.onSurface;
    final isSwipingLeft = _dragOffset < 0;
    final maxOffset = isImportant ? 120.0 : 0.0;
    final visibleOffset = _dragOffset.clamp(-120.0, maxOffset).toDouble();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      onHorizontalDragStart: (_) => _resetDrag(),
      onHorizontalDragUpdate: (details) {
        setState(() => _dragOffset += details.delta.dx);
      },
      onHorizontalDragEnd: (_) {
        final offset = _dragOffset;
        _resetDrag();

        if (offset <= -_swipeThreshold) {
          widget.onSwipeLeft();
        } else if (offset >= _swipeThreshold && isImportant) {
          widget.onSwipeRight();
        }
      },
      onHorizontalDragCancel: _resetDrag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            if (visibleOffset != 0)
              Positioned.fill(
                child: Container(
                  color: isSwipingLeft
                      ? colors.errorContainer
                      : colors.secondaryContainer,
                  alignment: isSwipingLeft
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    isSwipingLeft ? Icons.delete_outline : Icons.star_border,
                    color: isSwipingLeft
                        ? colors.onErrorContainer
                        : colors.onSecondaryContainer,
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(visibleOffset, 0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: isImportant
                    ? const Color(0xFFFFF3D4)
                    : colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isImportant
                        ? const Color(0xFFD7AC55)
                        : colors.outlineVariant,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  title: Text(
                    widget.note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      widget.note.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: typography.bodyMedium?.copyWith(
                        color: isImportant ? foreground : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  trailing: isImportant
                      ? Icon(
                          Icons.star,
                          color: foreground,
                          semanticLabel: 'Важная заметка',
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}