
import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

const Color purple = Color(0xFF7928CA);
const Color orange = Color(0xFFFF8A50);
const Color background = Color(0xFFF7F4FC);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// MODELO DE TAREFA

class Task {
  String title;
  DateTime date;
  bool completed;

  Task({
    required this.title,
    required this.date,
    this.completed = false,
  });
}

// LOGIN E CADASTRO

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRegister = false;

  void enterApp() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'TaskFlow',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: purple,
                ),
              ),
              const Text(
                'Organize seus dias. Conquiste seus objetivos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: purple.withOpacity(0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      isRegister ? 'Criar conta' : 'Bem-vindo de volta!',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: enterApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          isRegister ? 'CADASTRAR' : 'ENTRAR',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isRegister = !isRegister;
                        });
                      },
                      child: Text(
                        isRegister
                            ? 'Já possui conta? Entrar'
                            : 'Não possui conta? Cadastre-se',
                        style: const TextStyle(color: purple),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TELA PRINCIPAL

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  DateTime selectedDate = DateTime.now();
  DateTime displayedMonth = DateTime.now();

  final List<Task> tasks = [];

  String dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  List<Task> get dailyTasks {
    final result = tasks
        .where((task) => dateKey(task.date) == dateKey(selectedDate))
        .toList();

    result.sort((a, b) {
      if (a.completed != b.completed) {
        return a.completed ? 1 : -1;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return result;
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.add(
        Task(
          title: title.trim(),
          date: selectedDate,
        ),
      );
    });
  }

  void toggleTask(Task task, bool? value) {
    setState(() {
      task.completed = value ?? false;
    });
  }

  void removeTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  void showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova tarefa'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite sua tarefa...',
            prefixIcon: Icon(Icons.edit_note),
          ),
          onSubmitted: (value) {
            addTask(value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              addTask(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril',
      'Maio', 'Junho', 'Julho', 'Agosto',
      'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  Widget buildCalendar() {
    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateUtils.getDaysInMonth(
      displayedMonth.year,
      displayedMonth.month,
    );

    final offset = firstDay.weekday - 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  displayedMonth = DateTime(
                    displayedMonth.year,
                    displayedMonth.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left, color: purple),
            ),
            Text(
              formatDate(displayedMonth),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  displayedMonth = DateTime(
                    displayedMonth.year,
                    displayedMonth.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right, color: purple),
            ),
          ],
        ),
        const SizedBox(height: 15),
         Row(
          children: [
            'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'
          ].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 42,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            final day = index - offset + 1;

            if (day < 1 || day > daysInMonth) {
              return const SizedBox();
            }

            final date = DateTime(
              displayedMonth.year,
              displayedMonth.month,
              day,
            );

            final selected = dateKey(date) == dateKey(selectedDate);

            final hasTasks = tasks.any(
              (task) => dateKey(task.date) == dateKey(date),
            );

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selected ? purple : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? purple : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (hasTasks)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: selected ? orange : orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildCalendarScreen() {
    final count = tasks.where(
      (task) => dateKey(task.date) == dateKey(selectedDate),
    ).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu planejamento',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Escolha um dia e organize suas atividades.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.07),
                  blurRadius: 15,
                ),
              ],
            ),
            child: buildCalendar(),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple, Color(0xFFAC50E8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event_available,
                  color: Colors.white,
                  size: 35,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dia selecionado',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$count tarefa(s) cadastrada(s)',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: showAddDialog,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar tarefa neste dia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTasksScreen() {
    final pending = dailyTasks.where((task) => !task.completed).length;
    final completed = dailyTasks.where((task) => task.completed).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Minhas tarefas',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                      displayedMonth = date;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_month, color: purple),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _statCard('Pendentes', pending, orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard('Concluídas', completed, Colors.green),
              ),
            ],
          ),
        ),
        Expanded(
          child: dailyTasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 75,
                        color: purple.withOpacity(0.35),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Nenhuma tarefa por aqui!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      const Text(
                        'Adicione uma atividade para começar.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (pending > 0) ...[
                      const Text(
                        'PENDENTES',
                        style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...dailyTasks
                          .where((task) => !task.completed)
                          .map(buildTaskCard),
                    ],
                    if (completed > 0) ...[
                      const SizedBox(height: 15),
                      const Text(
                        'CONCLUÍDAS',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...dailyTasks
                          .where((task) => task.completed)
                          .map(buildTaskCard),
                    ],
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: showAddDialog,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar nova tarefa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTaskCard(Task task) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          activeColor: Colors.green,
          onChanged: (value) => toggleTask(task, value),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
          onPressed: () => removeTask(task),
        ),
      ),
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.checklist_rounded),
            SizedBox(width: 10),
            Text(
              'TaskFlow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: selectedTab == 0
          ? buildCalendarScreen()
          : buildTasksScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        indicatorColor: orange.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tarefas',
          ),
        ],
      ),
    );
  }
}
