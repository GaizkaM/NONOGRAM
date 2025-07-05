# Nonogram Solver (Prolog)

This project implements a nonogram solver using **Prolog** logic programming. It was developed as a final assignment for the **Programming Languages** course (2024-25 academic year).

## 📖 Description

The main goal of the application is to solve nonograms based on the row and column clues, using a declarative and recursive approach. The program does not generate a solution imperatively, but rather describes the conditions that a valid solution must satisfy. Key features:

- **Support for rectangular nonograms**: handles any combination of rows and columns.
- **Main predicate `nonograma/3`**: solves the nonogram and returns the solution grid.
- **Extensive documentation**: the code is heavily commented for better understanding.

### 🛠 Features

1. **Nonogram solving**:
   - Input: two lists with row and column clues.
   - Output: a matrix of 0s and 1s representing the solution.
   - Example:
     ```prolog
     ?- nonograma([[2], [1]], [[2], [1], []], Caselles).
     Caselles = [[1, 1, 0], [1, 0, 0]]
     ```

2. **Solution validation**:
   - You can check if a proposed solution is valid for given clues using the same predicate.
     ```prolog
     ?- nonograma(RowHints, ColHints, [[1,0],[1,1]]).
     true
     ```

3. **Support for variable dimensions**:
   - Supports nonograms of size NxM.
   - Example usage with 7x7:
     ```prolog
     RowHints = [[2,2],[2,2],[1,2],[3,1,1],[2,3],[5],[1,3]],
     ColHints = [[1,3],[2,2,1],[3,1],[1,2],[2,4],[2,3],[1,2]],
     nonograma(RowHints, ColHints, Cells).
     ```

---

## 🗂 Project Structure

- **Main predicate**:
  - `nonograma/3`: takes row and column clues and returns the solution.

- **Board generation**:
  - `generar_Caselles/3`: initializes the empty board.
  - `construir_tauler/3`, `construir_fila_buida/2`: build the variable matrix.

- **Constraint application**:
  - `aplicar_restriccions/2`: applies clues to each row.
  - `construir_fila/2`: builds each row based on its clue.
  - `bloc_mig/3`, `bloc_fi/2`: create the correct block structures of 1s and 0s.

- **Auxiliary functions**:
  - `emplenar_zeros/2`: fills a row with zeros.
  - `tots_zeros/1`: checks if a row has only zeros.
  - `generar_uns/2`: creates a list of 1s.
  - `dividir/3`: splits a list into all possible combinations.
  - `transposada/2`: transposes rows and columns to reuse row-processing logic on columns.

---

## 🚀 How It Works

1. **Initialization**:
   - Generates a matrix of Prolog variables with appropriate dimensions.

2. **Applying constraints**:
   - Applies the clues row by row.
   - Transposes the matrix to treat columns as rows and applies the same logic.

3. **Solution unification**:
   - Prolog explores all combinations of 0s and 1s that satisfy the clues.
   - A *green cut* is used to stop after the first valid solution is found.

---

## 🎯 Technical Highlights

- **Declarative approach**:
  - Avoids imperative structures. The code defines the conditions for a valid solution.

- **Recursion and backtracking**:
  - Heavy use of recursion to generate and validate rows.

- **Generality**:
  - Supports any nonogram size, including rectangular ones.

- **Optimization with cuts**:
  - Uses `!` to avoid unnecessary backtracking once a valid solution is found.

---

## 📝 Author

- **Gaizka Medina Gordo**  
