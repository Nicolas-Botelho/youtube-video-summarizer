#import "IFES-DOC/ifes-doc.typ": *
#show: setup.with(
  title: "Resumo de Vídeos do YouTube no Obsidian",
  subtitle: "Relatório do Trabalho",
  course: "Inteligência Artificial",
  author: "Breno Amâncio, Nicolas Botelho e Rafael Leão",
)

= Introdução

== Motivação

Atualmente, o YouTube é uma plataforma muito útil para apoio ao estudo e a obtenção de informações e conhecimento. Por exemplo, existem diversos canais focados para o ensino de diversos conteúdos em níveis variados de complexidade, como #link("https://www.youtube.com/@MatematicaRio", "Prof. Rafael Procópio"), focado em matemática, e #link("https://www.youtube.com/@josecarlosmacoratti", "José Carlos Macoratti"), focado em programação, principalmente .NET e C\#. Assim, se usado corretamente, o YouTube pode ser uma ferramenta importante na forma de estudo contemporânea.

== Problema

Nesse cenário, existe uma gama muito ampla de informações disponíveis, então, nem sempre é possível ir a fundo em todas elas. Além disso nem todas as fontes de informação são, de fato, relevantes em seu conteúdo.

== Proposta

Pensando nisso, e também no cenário de popularização de _Large Language Models_ (LLMs), como Gemini, ChatGPT e Claude, esse trabalho propõe uma ferramenta que usa LLM para gerar resumos de vídeos do YouTube e coloca esses resumos no #link("https://obsidian.md/", "Obsidian"), uma ferramenta gratuita e _offline_ de escrita de notas e gestão de conhecimento.

= Arquitetura

== Arquitetura da ferramenta

// TODO
// organização da ferramenta (exemplo: plugin do obsidian que chama um script python)

== Arquitetura do agente

// TODO
// agente e as tools usadas

= Resultados Obtidos

Para os testes realizados, foram utilizados os vídeos na tabela abaixo. Para simplificar a discussão sobre os vídeos, a cada um deles foi atribuido um identificador (ID).

#styled-table(
  headers: ("ID", "Nome do Vídeo", "Link do Vídeo"),
  rows: (
    ("V1", "Typst in 100 Seconds", link("https://youtu.be/kI2e0o3sIVM?si=Y46GcPPCs11JGB14")),
    ("V2", "INTEGRAL INDEFINIDA - Cálculo 1 (#41)", link("https://youtu.be/M_xCxHcBdBo?si=XqHeYGJeSChrhWNG")),
    ("V3", ".NET - Apresentando Clean Architecture", link("https://youtu.be/ZWfrI5Bu6so?si=Dow0uoeX7YMOE08T")),
    ("V4", "Five Tips for Writing Your First Novel", link("https://youtu.be/mMeNnX1FGgg?si=aL2_-HbUVE3urgHW")),
    ("V5", "LaTeX for Students – A Simple Quickstart Guide", link("https://youtu.be/lgiCpA4zzGU?si=yd-frPVgAcIDaQcX")),
  )
)

== Resultados para V1

O vídeo V1 é uma visão geral sobre o Typst, uma ferramenta de escrita de documentos, com o mesmo propósito do LaTeX. O vídeo explica rapidamente como utilizar a ferramenta e quais são suas principais funcionalides. O resumo gerado pode ser encontrado na @resumo-v1.

=== Chamadas de ferramentas (_tool calls_) e métricas

Para gerar o resumo do V1, o agente optou por usar as _tools_ _get youtube video data_ e _video transcript_.

A execução durou 6,0212 segundos e gastou um total de 1936 _tokens_, sem contar os _tokens_ gastos para _reasoning_ (458 _tokens_).

#styled-table(
  headers: ("Input tokens", "Output tokens", "Total tokens", "Reasoning tokens"),
  rows: (
    ("1376", "560", "1936", "458")
  ))

== Resultados para V2

O vídeo V2 é uma aula de cálculo sobre integrais indefinidas e a relação do cálculo delas com a derivação. O resumo gerado pode ser encontrado na @resumo-v2.

=== Chamadas de ferramentas (_tool calls_) e métricas

Para gerar o resumo do V2, o agente optou por usar a _tool_ _get youtube video captions_. Porém, a _tool_ não conseguiu encontrar legendas em inglês para o vídeo, então o agente usou a _tool_ _video transcript_ que retornou a legenda em português para o agente.

A execução durou 6,1789 segundos e gastou um total de 6170 _tokens_, sem contar os _tokens_ gastos para _reasoning_ (363 _tokens_).

#styled-table(
  headers: ("Input tokens", "Output tokens", "Total tokens", "Reasoning tokens"),
  rows: (
    ("5545", "625", "6170", "363")
  ))

== Resultados para V3

O vídeo V3 é uma aula introdutória a Arquitetura Limpa (_Clean Architecture_). O vídeo dá uma visão geral da arquitetura e dos princípios que a guiam. O resumo gerado pode ser encontrado na @resumo-v3.

=== Chamadas de ferramentas (_tool calls_) e métricas

Para gerar o resumo do V3, o agente optou por usar as _tools_ _get youtube video data_ e _get youtube video captions_. Porém, a _tool_ de legenda não conseguiu encontrar legendas em inglês para o vídeo, então o agente optou por usar a _tool_ _video transcript_ que retornou as legendas em português.

A execução durou 7,7084 segundos e gastou um total de 4824 _tokens_, sem contar os _tokens_ gastos para _reasoning_ (444 _tokens_).

#styled-table(
  headers: ("Input tokens", "Output tokens", "Total tokens", "Reasoning tokens"),
  rows: (
    ("3912", "912", "4824", "444")
  ))

== Resultados para V4

No vídeo V4, Brandon Sanderson dá 5 dicas sobre como um autor iniciante pode escrever o seu primeiro romance. O vídeo é feito na perspectiva do Mês Nacional da Escrita nos EUA, onde existe um desafio de escrever um romance até o final do mês. O resumo gerado pode ser encontrado na @resumo-v4.

=== Chamadas de ferramentas (_tool calls_) e métricas

Para gerar o resumo do V4, o agente optou por usar a _tool_ _video transcript_.

A execução durou 10,5473 segundos e gastou um total de 4747 _tokens_, sem contar os _tokens_ gastos para _reasoning_ (991 _tokens_).

#styled-table(
  headers: ("Input tokens", "Output tokens", "Total tokens", "Reasoning tokens"),
  rows: (
    ("3841", "906", "4747", "991")
  ))

== Resultados para V5

O vídeo V5 traz um guia básico de uso do LaTeX, focado em alunos que não tenham tido interação com a ferramenta. O resumo completo pode ser encontrado na @resumo-v5.

=== Chamadas de ferramentas (_tool calls_) e métricas

Para gerar o resumo do V5, o agente optou por usar as _tools_ _get youtube video captions_ e _get youtube video data_.

A execução durou 10,4244 segundos e gastou um total de 4731 _tokens_, sem contar os _tokens_ gastos para _reasoning_ (860 _tokens_)

#styled-table(
  headers: ("Input tokens", "Output tokens", "Total tokens", "Reasoning tokens"),
  rows: (
    ("3696", "1035", "4731", "860")
  ))

= Conclusão

== Avaliação

// TODO

== Limitações

// TODO

== Conclusão

// TODO

#pagebreak()
#set heading(numbering: "A.1")
#counter(heading).update(0)

= Apêndice A

== Resumo de V1 <resumo-v1>
```md
Here is a summary of the video about Typst:                               

*   **Introduction to Typst:**
This video is a fast-paced, "Fireship tribute" style introduction to Typst, a modern, blazingly fast, and Rust-based typesetting language. It was developed in 2019 by German university students seeking an alternative to LaTeX due to its awkward syntax and slow compilation speeds. Typst aims to provide a more efficient and user-friendly experience for creating     documents.                                                                
*   **Key Features and Performance:**
Typst stands out with its exceptional performance, utilizing incremental compilation and an advanced memoization scheme. This allows it to compile documents dramatically faster than LaTeX, often by orders of magnitude. It is capable of rendering various outputs including PDFs, images, HTML, and vector graphics, while supporting high-level scripting features.

*   **Getting Started and Basic Syntax:**
Users can get started with Typst by installing it locally using Cargo or by creating a free account on typst.app to use its web editor.
Documents are created with a `.typ` extension and compiled into PDFs (or other formats using the `-f` flag) using the `typst compile` command. The syntax is designed to be intuitive:
*   Text renders directly.
*   Dollar signs define inline math, which is less verbose than LaTeX.
*   Underscores create italics, similar to Markdown.
*   Spaces are used for multi-line math.
*   Fractions are defined with a simple slash.
*   The alt modifier accesses Greek characters.
*   Equal signs create headings, nestable up to five levels.
                  
*   **Advanced Scripting Capabilities:**
Typst truly shines with its powerful scripting features. Users can declare variables using `let` and reference them with `#`. The `range` function creates iterable objects, and the spread syntax combined with the `table` element can automatically generate columns. Functions can be defined with `let`, support implicit returns based on conditional logic, and are both recursive and first-class. These scripting features enable dynamic content generation and complex document structures.

*   **Customization and Ecosystem:**
The language provides `set` commands for customizing page layouts and heading numbering. Furthermore, Typst boasts a rich ecosystem of packages and templates, allowing users to create a wide variety of documents, from complex circuit diagrams to professional resumes, with ease and flexibility.

* **Conclusion:**
Typst presents itself as a compelling modern alternative to traditional typesetting systems. Its focus on speed, simplified syntax, and robust scripting capabilities makes it an attractive choice for anyone looking for an efficient and powerful document creation tool.
```

== Resumo de V2 <resumo-v2>
```md
This video introduces the concept of indefinite integrals as the inverse operation of differentiation, a fundamental topic in a complete Calculus I course. It emphasizes understanding integrals by relating them to finding the original function before derivation.

*   **Understanding Primitive Functions**: The core idea revolves around finding a "primitive function" (F(x)) such that its derivative is the given function (f(x)). The video illustrates this by showing how deriving F(x) = x³/3 + 5 and G(x) = x³/3 - 12 both result in f(x) = x². This highlights that a function can have multiple primitive functions that differ only by a constant.
*   **The Constant of Integration (C)**: A key point is the introduction of the constant 'C' in indefinite integrals. Since the derivative of any constant is zero, when reversing the differentiation process, an arbitrary constant must be added. This leads to a "family" of primitive functions for any given integrable function.
*   **Integral Notation**: The video explains the standard notation for an indefinite integral: ∫f(x) dx = F(x) + C. Here, '∫' is the integral symbol, 'f(x)' is the integrand, and 'dx' indicates that the integration is with respect to the variable 'x'.
*   **Properties of Integrals**: Two essential properties are discussed:
    *   **Constant Multiple Rule**: A constant multiplying a function inside an integral can be moved outside the integral sign (∫k * f(x) dx = k * ∫f(x) dx).
    *   **Sum/Difference Rule**: The integral of a sum or difference of functions can be separated into the sum or difference of their individual integrals (∫[f(x) ± g(x)] dx = ∫f(x) dx ± ∫g(x) dx).
*   **Applying Integration Techniques**: Several examples demonstrate how to find integrals using the inverse of differentiation and the properties. This includes integrating trigonometric functions (e.g., ∫sin(x) dx, ∫cos(x) dx) and exponential functions (e.g., ∫e^x dx), as well as power functions (e.g., ∫x dx).
*   **Table of Immediate Integrals**: The video stresses the importance of memorizing a table of common, or "immediate," integrals to save time and streamline the integration process. It also provides examples of using this table for more complex functions involving powers and trigonometric expressions.
*   **Importance of Derivatives and Trigonometry**: Throughout the video, the presenter reiterates that a solid understanding of differentiation rules and basic trigonometry is crucial for successfully learning and applying integral calculus.

In conclusion, this video serves as a foundational guide to understanding indefinite integrals. It clearly explains integrals as the reverse of differentiation, introduces the concept of primitive functions and the constant of integration, and covers fundamental properties and notation. The emphasis on practical examples and the recommendation to memorize common integral formulas provide a strong starting point for students of calculus.
```

== Resumo de V3 <resumo-v3>
```md
The video introduces Clean Architecture, a concept proposed by Uncle Bob, as a method for building highly flexible and maintainable software solutions. It emphasizes organizing a project to be easily understandable and adaptable as it grows.

### Introduction to Software Architecture
Before diving into Clean Architecture, the video defines software architecture as the design of a system in terms of its software components, their relationships, and the patterns and constraints that guide their composition. It's about organizing code into classes, files, components, or modules and how these groups interact, ultimately defining where the application executes its core functionality and how it interacts with other resources like databases and user interfaces.

### Core Concept of Clean Architecture
The foundation of Clean Architecture is the **Dependency Rule**, which states that source code dependencies can only point inwards. This means that inner layers should not know anything about outer layers. The architecture is represented by concentric circles, where each circle represents a different layer of the application. The goal is to separate the stable core business rules from volatile external components, making the system easy to change.

### The Concentric Layers Explained

*   **Entities (Innermost Circle):**
    *   Encapsulates the core business rules for the entire application.
    *   These rules are critical to the correct functioning of the application and exist independently of any specific application.
    *   Entities have no dependencies on any external layers.

*   **Use Cases (Second Circle):**
    *   Contains application-specific business rules.
    *   Determines the system's behavior by orchestrating the flow of data to and from entities, directing them to achieve specific goals.
    *   Use Cases interact with and depend on Entities but are unaware of the outermost layers (e.g., whether the interface is a web page or mobile app, or where data is stored). They define interfaces or use abstract classes for communication with external layers.

*   **Adapters (Third Circle):**
    *   Also known as interface adapters, they act as translators between the domain (Entities and Use Cases) and the infrastructure.
    *   They adapt input data from the user interface into a format suitable for Use Cases and Entities, and adapt output data from Use Cases and Entities for display on the UI or storage in the database.
    *   This layer might contain presenters, views, and controllers in an MVC architecture. Importantly, no code in this layer should know anything about the database.

*   **Infrastructure (Outermost Circle):**
    *   This layer houses all input/output components, including the user interface, databases, frameworks, devices, etc.
    *   It contains all the "details" of the application, such as the UI and database, which are highly volatile and prone to frequent changes.
    *   This layer is kept as far as possible from the domain layers to facilitate easy changes or swapping of components without affecting the core business rules. There is no direct dependency between this layer and the others.

### Communication Between Layers
Communication across layer boundaries is achieved through the **Dependency Inversion Principle**. Instead of a direct call that would violate the Dependency Rule (e.g., a Use Case calling a Presenter directly), an inner layer (e.g., a Use Case) calls an interface (an "output port"), and an outer layer (e.g., the Presenter) implements that interface. This ensures dependencies always point inwards.

### Data Crossing Boundaries
Data passing between layers should use simple, isolated data structures like Data Transfer Objects (DTOs). This prevents data structures from introducing dependencies that violate the Dependency Rule. Data can be passed as arguments in method calls, packed into hashmaps, or transported in dedicated data objects.

### Assembling Components
To bring all components together while maintaining their interdependence, a "Main" module is used. This Main module depends on all other components to wire them up, but no other component depends on Main. This setup leverages interfaces extensively, ensuring components don't need to know about each other's implementations.

### Conclusion
Clean Architecture provides a structured approach to software design that prioritizes separation of concerns, testability, and maintainability. By strictly adhering to the Dependency Rule and organizing code into well-defined, independent layers, the architecture allows for significant flexibility and sustainability, making it easier to evolve and adapt the application over time. The extensive use of interfaces is a key aspect of achieving this independence and flexibility.
```

== Resumo de V4 <resumo-v4>
```md
Here's a summary of the video, focusing on its context and main points:

*   **Introduction to National Novel Writing Month (NaNoWriMo):**
    The video introduces National Novel Writing Month, an annual challenge for writers to compose a 50,000-word novel within a single month. Brandon, the speaker and a successful author (whose book "The Way of Kings" originated from a NaNoWriMo challenge), highlights the event's purpose: to break writers out of ruts, encourage turning off the "internal editor," and simply write. He acknowledges that while it's a worthy challenge, it might not suit every writer's psychology, and abandonment is an option if it doesn't work. The video then delves into five "hacks" for those attempting the challenge, particularly with minimal preparation.

*   **Hack 1: Borrowing Your Structure:**
    This strategy involves taking inspiration from existing stories, movies, or genres that a writer enjoys. The idea is to analyze and distill the fundamental structural elements of these successful narratives (e.g., the setup, character recruitment, planning, and execution in a heist story). Writers can then rebuild this borrowed structure with new characters, a new problem, and their own unique character arcs. Transposing genres (e.g., using a Regency romance structure for a Western) can add originality. This method provides a ready-made outline, offering "training wheels" that are especially useful for writing a novel quickly, though adaptation to one's own story is crucial.

*   **Hack 2: Begin with a Monologue:**
    To deeply understand a character, even for stories not told in the first person, writers are encouraged to start by writing a monologue from that character's perspective. This involves imagining the character explaining a significant period or event in their life. While these monologues might not appear directly in the final draft, they can become valuable character-building exercises, or even be repurposed as chapter epigraphs, journal entries, or form the basis of an epistolary novel (a novel told through letters, diary entries, etc.).

*   **Hack 3: Character's Wants vs. Needs:**
    A strong story is character-centric. This hack advises writers to explore what their character *wants*, what they *need*, how these differ, and why they cannot have either. This exploration helps in generating plot spontaneously by creating obstacles that prevent the character from achieving their desires. It ensures the story revolves around the character's internal and external struggles. The speaker cautions against having a passive protagonist who merely observes, emphasizing the importance of choosing a viewpoint character who is undergoing significant change, experiencing conflict, or actively pursuing their goals.

*   **Hack 4: Choose Your Type of Progress:**
    Stories are fundamentally built on a promise, progress toward that promise, and a payoff. The "progress" forms the bulk of the narrative and is what makes a story a "page-turner." Writers must decide and "signpost" the type of progress readers can expect. Examples include:
    *   **Travelogue:** Physical journey towards a destination, like characters moving across a map.
    *   **Clues/Information:** In mysteries, the gradual accumulation of information that clarifies a central puzzle.
    Clear signposting of progress is vital for good pacing; readers often complain about slow stories when the author fails to indicate how the narrative is moving forward. It's also important to align the signposted progress with the story's actual genre to manage reader expectations.

*   **Hack 5: Prime Your Mind:**
    The final piece of advice, though cut short in the transcript, begins with the suggestion to "prime your mind." This typically involves engaging in a different activity before writing to prepare one's mental state for the creative process.

*   **Conclusion:**
    Brandon's guidance for National Novel Writing Month offers practical, actionable strategies aimed at facilitating rapid novel creation. By encouraging writers to strategically borrow story structures, delve deeply into character through introspective monologues, define their protagonists' wants and needs, and clearly delineate the narrative's progression, these "hacks" provide a robust framework. The overarching message is to maintain forward momentum and focus on a character-driven plot to successfully navigate the demanding challenge of writing a novel in a single month.
```

== Resumo de V5 <resumo-v5>
```md
This video, "LaTeX for Students – A Simple Quickstart Guide" by Jake B, serves as an introductory guide for students on how to easily get started with LaTeX, a powerful document preparation system. The video aims to simplify the process, moving beyond overly complex tutorials to provide a practical foundation for new users.

### Introduction to LaTeX
LaTeX is presented as a software system for document preparation, functioning like a markup or programming language. It is renowned for producing professional-looking documents and is widely used in STEM fields for its high-quality typesetting. The video encourages students, especially those in math and science, to adopt LaTeX for their academic work due to its numerous advantages over traditional word processors.

### Getting Started with Overleaf
The tutorial strongly recommends using Overleaf (overleaf.com), a cloud-based LaTeX editor, comparing it to Google Docs for its collaborative and accessible nature. It outlines the process of signing up, creating a new blank project, and introduces the three main panels: the file browser, the text editor, and the compiled document preview. A useful tip given is to draft content in other programs like Word or Google Docs and then paste it into Overleaf for formatting, rather than writing directly in the LaTeX editor.

### Basic Document Structure
The video dives into the fundamental structure of a LaTeX document:
*   **Preamble:** This section, located above `\begin{document}`, is crucial for configuring document settings. It defines the document class (e.g., `article` for a basic paper, `book` for a book with chapters), input encoding (`\usepackage[utf8]{inputenc}`), and document metadata like title, author, and date (`\title{}`, `\author{}`, `\date{}`). The `\maketitle` command is used to display this information.
*   **Sections and Subsections:** LaTeX provides commands like `\section{}` and `\subsection{}` to organize content hierarchically, with automatic numbering (e.g., Section 1, Subsection 1.1).

### Writing Math Equations
One of LaTeX's most powerful features for students is its ability to typeset complex mathematical equations beautifully.
*   **Math Packages:** Essential math functionalities are enabled by adding packages like `amsmath`, `amssymb`, and `amsfonts` to the preamble.
*   **Inline Math:** Equations that appear within a line of text are enclosed by dollar signs (e.g., `$e=mc^2$`).
*   **Displayed/Numbered Equations:** For larger, standalone, and often numbered equations, the `\begin{equation} ... \end{equation}` environment is used.
*   **Special Symbols and Commands:** LaTeX offers a vast array of commands for mathematical symbols (e.g., `\sum` for summation).
*   **Detexify:** A valuable online tool called Detexify is introduced, allowing users to draw a mathematical symbol and receive its corresponding LaTeX command.

### Including Images
Integrating images into LaTeX documents is also covered, though it can be a bit more involved initially.
*   **Setup:** This involves creating an `images` folder for storing image files and adding `\usepackage{graphicx}` and `\usepackage{float}` to the preamble. The graphics path is specified using `\graphicspath{{images/}}`.
*   **Figure Environment:** Images are placed within a `\begin{figure}[H] ... \end{figure}` environment, with `[H]` ensuring precise placement.
*   **Commands:** `\caption{}` adds a caption, and `\includegraphics[width=5in]{photo.png}` includes the image, allowing for precise control over its width.
*   **Troubleshooting:** The video addresses common issues like the "overfull \hbox too wide" warning, which indicates an image is too wide for the margins and can be resolved by adjusting the `width` parameter.

### Basic Customization
LaTeX offers extensive customization options for document appearance:
*   **Page Setup (Geometry):** The `\usepackage[letterpaper, margin=1in]{geometry}` command in the preamble allows for easy modification of paper size and all page margins.
*   **Line Spacing:** The `\linespread{}` command can be used to adjust line spacing (e.g., `\linespread{1.15}` for 1.15 spacing, `\linespread{1.667}` for double spacing).
*   **Paragraph Formatting:** `\setlength{\parindent}{0em}` removes paragraph indentation, while `\setlength{\parskip}{0.8em}` adds vertical space between paragraphs, enhancing readability.

### Conclusion
The video concludes by reiterating the long-term benefits of learning and using LaTeX, despite the initial learning curve. It encourages perseverance, assuring students that the effort is worthwhile for producing professional-quality documents. The importance of utilizing online resources and quick Google searches for troubleshooting is emphasized as a key strategy for overcoming challenges.
```