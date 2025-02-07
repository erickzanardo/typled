abstract class Command<T> {
  const Command({
    required this.command,
    required this.description,
    required this.usage,
  });

  final String command;
  final String description;
  final String usage;

  void execute(T subject, List<String> args);
}
