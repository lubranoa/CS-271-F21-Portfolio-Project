<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

<!-- Centered title section with descriptive lines -->
<div align="center">
  <!-- Title Section Links -->
  <p>
    <a href="www.linkedin.com/in/lubrano-alexander">
      <img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin" alt="linkedin link" />
    </a>
    <a href="https://lubranoa.github.io">
      <img src="https://img.shields.io/badge/Personal_Site-47b51b?style=for-the-badge" alt="personal website link" />
    </a>
    <a href="https://github.com/lubranoa">
      <img src="https://img.shields.io/badge/GitHub-8A2BE2?style=for-the-badge&logo=github" alt="github profile link" />
    </a>
  </p>
  <!-- Titles and Subtitles -->
  <h1 align="center">Low-Level I/O Procedures in Assembly</h1>
  <p align="center">
    <b>An Interactive Program in MASM-style x86-32 Assembly for Data Input, Validation, and Manipulation using String Primitives and Macros</b>
  </p>
  <p align="center">
    Fall 2021 · <a href="https://ecampus.oregonstate.edu/soc/ecatalog/ecoursedetail.htm?subject=CS&coursenumber=271&termcode=ALL">CS 271 - Computer Architecture and Assembly Language </a> · Oregon State University
  </p>
  <br />
</div>

<!-- Table of Contents -->
<details>
  <summary>Table of Contents</summary>
    
  - [Project Description](#project-description)
  - [Technologies Used](#technologies-used)
  - [Features](#features)
  - [Usage](#usage)
  - [Skills Used](#skills-used)
    - [Skill 1](#skill-1)
    - [Skill 2](#skill-2)
  - [Contact](#contact)
  - [Acknowledgements](#acknowledgements)

</details>

<!-- Project Description -->
## Project Description
This program is an x86 assembly language program designed to perform string processing and low-level I/O operations. It involves the implementation of macros for string processing and procedures for handling signed integers using string primitive instructions. The program gets some user input of signed integers, validates each, then shows the user the numbers they entered along with the results of some arithmetic operations using those numbers. The program is formatted in accordance with the [CS271 Style Guide](/docs/CS271%20Style%20Guide.pdf).

<!-- Technologies Used -->
## Technologies Used
   - [![x86-asm][x86-asm]][x86-asm-url]
   - [![irvine32][irvine32]][irvine32-url] (for Pre-built I/O Procedures)
   - [![masm][masm]][masm-url]
   - [![visual-studio][visual-studio]][visual-studio-url]

<!-- Features -->
## Features
  - Prints an introduction and instructions to show the user hello and how to use the program.
  - Validates each of the entered signed decimal integers for incorrect characters.
  - Converts the strings to integers to calculate the sum and truncated average of the numbers.
  - Prints the numbers and results of the calculations back to the user and exits.
  - All strings are printed to the user using a macro.
  - All user input is captured using using a macro.
  - Uses some pre-built Input/Output procedures from the Irvine32 Library.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Usage -->
## Usage
To use this program, the project must be opened in Visual Studio 2019 using the project's [solution file](/Project.sln). The program will not work unless the Irvine32 Library has been successfully extracted into the `C:\` directory, which was the required installation location for this course. The `Irvine.zip` file can be downloaded from the web page ["Getting Started with MASM and Visual Studio 2019"](http://www.asmirvine.com/gettingStartedVS2019/index.htm) by Kip Irvine. This also contains environment setup and running instructions that may be different than what the professor of CS 271 required.

To run the program after opening `Project.sln` in Visual Studio, go to debug and select 'Run Without Debugging' or press `Ctrl` + `F5`. Then, follow directions until the end of the program. The output should look like the example below.

```
Written by: Alexander Lubrano

Please provide 10 signed decimal integers.
Each number needs to be small enough to fit inside a 32-bit register. After you have
finished entering the raw numbers, this program will display a list of the integers, their
sum, and their average value.

Please enter a signed integer: 138
Please enter a signed integer: -9
Please enter a signed integer: +22
Please enter a signed integer: 12912
Please enter a signed integer: 53j9332
ERROR: You did not enter a signed integer or your integer was too big.
Please try again: 903214o
ERROR: You did not enter a signed integer or your integer was too big.
Please try again: 47
Please enter a signed integer: -0
Please enter a signed integer: 000000000
Please enter a signed integer: 8318502012351883912345
ERROR: You did not enter a signed integer or your integer was too big.
Please try again: '1'
ERROR: You did not enter a signed integer or your integer was too big.
Please try again: \n
ERROR: You did not enter a signed integer or your integer was too big.
Please try again: 84
Please enter a signed integer: -1399023
Please enter a signed integer: 832

You entered the following numbers:
138, -9, 22, 12912, 47, 0, 0, 84, -1399023, 832
The sum of these numbers is: -1384997
The truncated average is: -138499

Hope this was fun!
- Alex
Press any key to continue . . .
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Skills Used
#### Skill 1:
  - description
#### Skill 2:
  - description

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Contact -->
## Contact
Alexander Lubrano - <a href="mailto:lubrano.alexander@gmail.com">lubrano.alexander@gmail.com</a> - <a href="www.linkedin.com/in/lubrano-alexander">LinkedIn</a>

Project Link: <a href="https://github.com/lubranoa/CS-271-F21-Portfolio-Project">https://github.com/lubranoa/CS-271-F21-Portfolio-Project</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Acknowledgements -->
## Acknowledgements
  - <a href="https://www.intel.com/content/www/us/en/content-details/782158/intel-64-and-ia-32-architectures-software-developer-s-manual-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4.html?wapkw=intel%2064%20and%20ia-32%20architectures%20software%20developer%27s%20manual&docid=782159">Intel 64 and IA-32 Architectures Software Developer’s Manual</a>
  - <a href="https://learn.microsoft.com/en-us/cpp/assembler/masm/microsoft-macro-assembler-reference?view=msvc-170">Microsoft Macro Assembler (MASM) Reference</a>
  - <a href="http://www.asmirvine.com/index.htm">"Assembly Language for x86 Processors" by Kip Irvine</a>
  - <a href="https://visualstudio.microsoft.com/">Visual Studio 2019</a>
  - [CS 271 Style Guide](/docs/CS271%20Style%20Guide.pdf)
  - <a href="https://shields.io/">Shields.io</a>
  - <a href="https://simpleicons.org/">Simple Icons</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Markdown links -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[x86-asm]: https://img.shields.io/badge/x86--32_Assembly_Language-grey?style=for-the-badge
[x86-asm-url]: https://www.intel.com/content/www/us/en/content-details/782158/intel-64-and-ia-32-architectures-software-developer-s-manual-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4.html?wapkw=intel%2064%20and%20ia-32%20architectures%20software%20developer%27s%20manual&docid=782159

[masm]: https://img.shields.io/badge/Microsoft_Macro_Assembler_(MASM)-grey?style=for-the-badge
[masm-url]: https://learn.microsoft.com/en-us/cpp/assembler/masm/microsoft-macro-assembler-reference?view=msvc-170

[visual-studio]: https://img.shields.io/badge/Visual_Studio_2019-grey?style=for-the-badge&logo=visualstudio&logoColor=5C2D91
[visual-studio-url]: https://visualstudio.microsoft.com/

[irvine32]: https://img.shields.io/badge/Irvine32_Library-grey?style=for-the-badge
[irvine32-url]:http://www.asmirvine.com/gettingStartedVS2019/index.htm