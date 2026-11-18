
% ============================================================================
% BAI31123 Knowledge Representation - Group Project Expert System
% Subject: Programming Language Recommendation System
% Group Members: Tay Jie Ren, Tay Qi Yun, Lim Ehang
% ============================================================================

:- use_module(library(readutil)).

:- dynamic known/2.
:- dynamic last_decision/3.

% ----------------------------------------------------------------------------
% Entry Point & Session Control
% ----------------------------------------------------------------------------

start :-
    reset_memory,
    nl,
    writeln('================================================================'),
    writeln('   Programming Language Recommendation Expert System'),
    writeln('================================================================'),
    writeln('Answer each question with y (yes) or n (no).'),
    nl,
    run_advisor.

reset_memory :-
    retractall(known(_, _)),
    retractall(last_decision(_, _, _)).

run_advisor :-
    recommend(Language, Summary, Trace),
    !,
    assertz(last_decision(Language, Summary, Trace)),
    nl,
    writeln('----------------------------------------------------------------'),
    format('Recommended Language: ~w~n', [Language]),
    format('Reason: ~w~n', [Summary]),
    writeln('----------------------------------------------------------------'),
    prompt_why.

run_advisor :-
    assertz(last_decision(unknown, none, [])),
    nl,
    writeln('----------------------------------------------------------------'),
    writeln('Result: Could not find a definitive match.'),
    writeln('No single language satisfied all of your project criteria.'),
    nl,
    writeln('Requirements checked during this session:'),
    print_known_facts,
    nl,
    writeln('General-purpose fallback recommendation:'),
    writeln('  Consider Python (for backend, scripting, or data tasks) or'),
    writeln('  JavaScript (for web and cross-platform application tasks).'),
    writeln('----------------------------------------------------------------'),
    prompt_why.

% ----------------------------------------------------------------------------
% Layer 3: Conclusion Rules (6 Outcomes, 12 Rules)
% ----------------------------------------------------------------------------

% Outcome 1: Python (2 rules)

recommend('Python',
          'Ideal for machine learning, data science, and AI workflows.',
          [workload_profile(data_and_ai),
           constraint_profile(productivity_first)]) :-
    workload_profile(data_and_ai),
    constraint_profile(productivity_first),
    lacks_trait(runs_in_browser).

recommend('Python',
          'Ideal for rapid prototyping, scripting, and fast backend automation.',
          [workload_profile(rapid_development),
           constraint_profile(productivity_first)]) :-
    workload_profile(rapid_development),
    constraint_profile(productivity_first),
    lacks_trait(runs_in_browser),
    lacks_trait(native_mobile),
    lacks_trait(manages_relational_db).


% Outcome 2: JavaScript / TypeScript (2 rules)

recommend('JavaScript / TypeScript',
          'Ideal for web frontend and interactive browser applications.',
          [target_platform(web_browser),
           constraint_profile(client_responsive)]) :-
    target_platform(web_browser),
    constraint_profile(client_responsive).

recommend('JavaScript / TypeScript',
          'Ideal for rapid browser-based web development and UI iteration.',
          [target_platform(web_browser),
           constraint_profile(productivity_first)]) :-
    target_platform(web_browser),
    constraint_profile(productivity_first).


% Outcome 3: C++ (2 rules)

recommend('C++',
          'Ideal for high-performance systems programming, graphics, and game engines.',
          [workload_profile(systems_and_graphics),
           constraint_profile(hardware_close)]) :-
    workload_profile(systems_and_graphics),
    constraint_profile(hardware_close),
    lacks_trait(runs_in_browser).

recommend('C++',
          'Ideal for embedded software and tools needing direct memory or hardware control.',
          [constraint_profile(hardware_close)]) :-
    constraint_profile(hardware_close),
    lacks_trait(runs_in_browser),
    lacks_trait(native_mobile).


% Outcome 4: Kotlin / Swift (2 rules)

recommend('Kotlin / Swift',
          'Ideal for interactive native iOS and Android mobile app development.',
          [target_platform(mobile_device),
           constraint_profile(client_responsive)]) :-
    target_platform(mobile_device),
    constraint_profile(client_responsive).

recommend('Kotlin / Swift',
          'Ideal for native mobile applications without low-level systems constraints.',
          [target_platform(mobile_device)]) :-
    target_platform(mobile_device),
    lacks_trait(needs_low_level_control).


% Outcome 5: Java (2 rules)

recommend('Java',
          'Ideal for large-scale enterprise backend architectures and microservices.',
          [target_platform(server_or_cloud),
           workload_profile(enterprise_services),
           constraint_profile(enterprise_reliable)]) :-
    target_platform(server_or_cloud),
    workload_profile(enterprise_services),
    constraint_profile(enterprise_reliable).

recommend('Java',
          'Ideal for statically typed, cross-platform backend and desktop applications.',
          [constraint_profile(enterprise_reliable)]) :-
    constraint_profile(enterprise_reliable),
    lacks_trait(runs_in_browser),
    lacks_trait(native_mobile),
    lacks_trait(manages_relational_db),
    lacks_trait(needs_rapid_prototyping).


% Outcome 6: SQL (2 rules)

recommend('SQL',
          'Ideal for relational database manipulation, schemas, and data retrieval.',
          [target_platform(database_engine),
           workload_profile(structured_data_ops)]) :-
    target_platform(database_engine),
    workload_profile(structured_data_ops).

recommend('SQL',
          'Ideal for direct relational database querying in productivity-focused tools.',
          [target_platform(database_engine),
           constraint_profile(productivity_first)]) :-
    target_platform(database_engine),
    constraint_profile(productivity_first),
    lacks_trait(runs_in_browser).


% ----------------------------------------------------------------------------
% Layer 2: Middle-Layer Concepts (14 Rules across 3 Conceptual Groups)
% ----------------------------------------------------------------------------

% Group A: Target Platform (5 rules)

target_platform(web_browser) :-
    has_trait(runs_in_browser),
    has_trait(needs_ui_interactivity).

target_platform(web_browser) :-
    has_trait(runs_in_browser),
    lacks_trait(needs_low_level_control).

target_platform(mobile_device) :-
    has_trait(native_mobile),
    lacks_trait(runs_in_browser).

target_platform(server_or_cloud) :-
    has_trait(enterprise_scale),
    lacks_trait(runs_in_browser).

target_platform(database_engine) :-
    has_trait(manages_relational_db),
    lacks_trait(needs_ui_interactivity).


% Group B: Workload Profile (5 rules)

workload_profile(data_and_ai) :-
    has_trait(handles_ml_data),
    lacks_trait(needs_low_level_control).

workload_profile(rapid_development) :-
    has_trait(needs_rapid_prototyping),
    lacks_trait(needs_max_speed).

workload_profile(systems_and_graphics) :-
    has_trait(needs_low_level_control),
    has_trait(needs_max_speed).

workload_profile(enterprise_services) :-
    has_trait(enterprise_scale),
    has_trait(needs_cross_platform_jvm).

workload_profile(structured_data_ops) :-
    has_trait(manages_relational_db),
    lacks_trait(handles_ml_data).


% Group C: Constraint Profile (4 rules)

constraint_profile(productivity_first) :-
    has_trait(needs_rapid_prototyping),
    lacks_trait(needs_low_level_control).

constraint_profile(hardware_close) :-
    has_trait(needs_low_level_control),
    lacks_trait(needs_rapid_prototyping).

constraint_profile(client_responsive) :-
    has_trait(needs_ui_interactivity),
    lacks_trait(manages_relational_db).

constraint_profile(enterprise_reliable) :-
    has_trait(needs_cross_platform_jvm),
    lacks_trait(needs_low_level_control).


% ----------------------------------------------------------------------------
% Layer 1: Asking & Memoization Layer
% ----------------------------------------------------------------------------

has_trait(Trait) :-
    ask_trait(Trait, yes).

lacks_trait(Trait) :-
    ask_trait(Trait, no).

ask_trait(Trait, Expected) :-
    known(Trait, Recorded),
    !,
    Recorded == Expected.

ask_trait(Trait, Expected) :-
    question_text(Trait, Question),
    format('~w (y/n): ', [Question]),
    flush_output,
    read_yes_no(Answer),
    assertz(known(Trait, Answer)),
    Answer == Expected.


% ----------------------------------------------------------------------------
% Input Validation
% ----------------------------------------------------------------------------

read_yes_no(Answer) :-
    read_line_to_string(user_input, Raw),
    (   Raw == end_of_file
    ->  nl,
        writeln('Input ended. Exiting expert system.'),
        halt(0)
    ;   normalize_space(string(Trimmed), Raw),
        string_lower(Trimmed, Lower),
        parse_yes_no(Lower, Answer)
    ).

parse_yes_no("", Answer) :-
    !,
    read_yes_no(Answer).

parse_yes_no("y", yes) :- !.
parse_yes_no("yes", yes) :- !.
parse_yes_no("y.", yes) :- !.
parse_yes_no("yes.", yes) :- !.

parse_yes_no("n", no) :- !.
parse_yes_no("no", no) :- !.
parse_yes_no("n.", no) :- !.
parse_yes_no("no.", no) :- !.

parse_yes_no(_, Answer) :-
    writeln('  Invalid input. Please type y (yes) or n (no).'),
    write('  Your answer (y/n): '),
    flush_output,
    read_yes_no(Answer).


% ----------------------------------------------------------------------------
% Questions & Human-Readable Labels
% ----------------------------------------------------------------------------

question_text(runs_in_browser,
    'Is the project meant to run directly inside a web browser?').

question_text(native_mobile,
    'Are you building a native mobile application (iOS or Android)?').

question_text(handles_ml_data,
    'Does the project involve machine learning, AI, or data analysis?').

question_text(needs_low_level_control,
    'Is low-level memory management or direct hardware control essential?').

question_text(needs_max_speed,
    'Is maximum execution speed or real-time performance critical?').

question_text(enterprise_scale,
    'Are you building a large-scale enterprise backend or server microservice?').

question_text(manages_relational_db,
    'Do you need to directly query and manage relational database schemas?').

question_text(needs_rapid_prototyping,
    'Is rapid prototyping or fast development more important than raw speed?').

question_text(needs_ui_interactivity,
    'Does the project require rich interactive client-side user interfaces?').

question_text(needs_cross_platform_jvm,
    'Do you need strict static typing and mature cross-platform portability?').


% ----------------------------------------------------------------------------
% Trait Labels
% ----------------------------------------------------------------------------

trait_label(runs_in_browser,
    'Runs directly in a web browser').

trait_label(native_mobile,
    'Native mobile application').

trait_label(handles_ml_data,
    'Machine learning / AI / data analysis').

trait_label(needs_low_level_control,
    'Low-level memory / hardware control').

trait_label(needs_max_speed,
    'Maximum execution speed').

trait_label(enterprise_scale,
    'Large-scale enterprise backend / microservice').

trait_label(manages_relational_db,
    'Direct relational database schema querying').

trait_label(needs_rapid_prototyping,
    'Rapid prototyping prioritized').

trait_label(needs_ui_interactivity,
    'Rich interactive client UI').

trait_label(needs_cross_platform_jvm,
    'Strict static typing & cross-platform portability').

trait_label(Other, Other).


% ----------------------------------------------------------------------------
% Explanation Layer (Interactive Prompt + Standalone why. Predicate)
% ----------------------------------------------------------------------------

prompt_why :-
    nl,
    write('Ask why? (y/n): '),
    flush_output,
    read_yes_no(Reply),
    (   Reply == yes
    ->  why
    ;   writeln('Session complete. (Tip: type "why." anytime to view the explanation.)')
    ).


% Explanation when no recommendation is found

why :-
    last_decision(unknown, none, _),
    !,
    nl,
    writeln('=== Explanation (No Definitive Match) ==='),
    writeln('None of the 6 language rules had all middle-layer conditions met.'),
    writeln('Recorded user answers:'),
    print_known_facts.


% Explanation when a recommendation is found

why :-
    last_decision(Language, Summary, Trace),
    !,
    nl,
    format('=== Explanation for: ~w ===~n', [Language]),
    format('Conclusion: ~w~n~n', [Summary]),
    writeln('Conditions supporting this recommendation:'),
    print_rule_explanations(Trace),
    nl,
    writeln('What you told the system:'),
    print_known_facts.


% Explanation when no session has been run

why :-
    writeln('No session has been run yet. Type "start." to begin.').


% ----------------------------------------------------------------------------
% Print Rule Explanations
% ----------------------------------------------------------------------------

print_rule_explanations([]).

print_rule_explanations([Rule | Rest]) :-
    once(rule_explanation(Rule, Text)),
    format('  * ~w -> ~w~n', [Rule, Text]),
    print_rule_explanations(Rest).


% ----------------------------------------------------------------------------
% Human-Readable Rule Explanations
% ----------------------------------------------------------------------------

rule_explanation(target_platform(web_browser),
    'Target platform classified as a browser-based web environment.').

rule_explanation(target_platform(mobile_device),
    'Target platform classified as native mobile (iOS/Android), not browser.').

rule_explanation(target_platform(server_or_cloud),
    'Target platform classified as enterprise server / backend infrastructure.').

rule_explanation(target_platform(database_engine),
    'Target platform classified as direct relational database operations.').


rule_explanation(workload_profile(data_and_ai),
    'Workload involves AI/ML or data analysis without low-level memory control.').

rule_explanation(workload_profile(rapid_development),
    'Workload prioritizes rapid development over maximum execution speed.').

rule_explanation(workload_profile(systems_and_graphics),
    'Workload requires both low-level memory control and maximum speed.').

rule_explanation(workload_profile(enterprise_services),
    'Workload targets enterprise services with strict static typing portability.').

rule_explanation(workload_profile(structured_data_ops),
    'Workload focuses on structured relational data rather than ML modeling.').


rule_explanation(constraint_profile(productivity_first),
    'Constraints favor fast prototyping over low-level hardware control.').

rule_explanation(constraint_profile(hardware_close),
    'Constraints demand low-level control over rapid prototyping.').

rule_explanation(constraint_profile(client_responsive),
    'Constraints require interactive client UI rather than pure DB management.').

rule_explanation(constraint_profile(enterprise_reliable),
    'Constraints require static typing portability without low-level memory management.').


rule_explanation(high_speed_needed,
    'Maximum execution speed / real-time performance was marked critical.').

rule_explanation(Other, Text) :-
    format(string(Text), 'Condition satisfied: ~w', [Other]).


% ----------------------------------------------------------------------------
% Print Recorded User Answers
% ----------------------------------------------------------------------------

print_known_facts :-
    findall(Trait-Val, known(Trait, Val), Facts),
    (   Facts == []
    ->  writeln('  (No questions were answered.)')
    ;   print_fact_list(Facts)
    ).


print_fact_list([]).

print_fact_list([Trait-Val | Rest]) :-
    once(trait_label(Trait, Label)),
    format('  - ~w: ~w~n', [Label, Val]),
    print_fact_list(Rest).

% ============================================================================
% END OF PROGRAM
% ============================================================================
