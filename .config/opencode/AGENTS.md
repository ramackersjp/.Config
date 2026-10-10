# General Instructions

## Language

- Always communicate with me in Dutch.
- All explanations, questions, progress updates, troubleshooting guidance and conversational responses must be in Dutch.
- Keep technical terms, API names, commands, filenames and code identifiers in their original form when appropriate.
- Write all code comments in English.
- Write all documentation in English unless I explicitly request another language.
- Write all Git commit messages in English.
- Write all GitHub pull request titles, descriptions, summaries and other PR content in English.
- When creating or reviewing a pull request, communicate with me in Dutch, but write the actual PR content in English.

## General Working Principles

- Inspect the existing codebase and relevant documentation before making changes.
- Follow the project's existing conventions and architecture unless there is a good reason to change them.
- Prefer simple, maintainable solutions over unnecessary complexity.
- Do not make unrelated changes.
- Explain important decisions and potential trade-offs in Dutch.
- Run relevant tests, linters and build commands after making changes when practical.
- Never claim that tests or builds passed unless they were actually executed successfully.
- Ask for clarification when an important requirement is ambiguous rather than making risky assumptions.

## Code Style and Quality

- **Keep code concise.** Prefer the simplest implementation that is easy to understand, maintain, and extend. Avoid unnecessary abstractions, boilerplate, duplication, and excessive indirection.
- **Avoid unnecessary comments and annotations.** Code should explain itself through clear naming and structure. Add comments only when the reasoning, intent, or behavior would otherwise be difficult to understand. Never add comments that merely repeat what the code already does.
- **No emojis or smileys in code.** Never include emojis or smileys in source code, comments, identifiers, strings, or commit-related code artifacts unless explicitly requested or required by the application.
- **Minimize code size without sacrificing clarity.** If the same functionality can be implemented clearly in 2,000 lines instead of 6,000, prefer the smaller implementation. Remove redundant code and avoid unnecessary complexity. Do not sacrifice readability, maintainability, correctness, or appropriate separation of concerns just to reduce line count.
- **Avoid overengineering.** Do not introduce abstractions, helper functions, classes, dependencies, or configuration options unless they provide a clear benefit.
- **Follow existing project conventions.** Apply these rules consistently while respecting the project's established architecture, language conventions, and formatting requirements.

## Task Completion & Validation

A task is not complete merely because the implementation is finished. You MUST verify that the requested outcome has actually been achieved before reporting completion.

### 1. Track Requirements
- Identify all explicit requirements, constraints, and expected outcomes before starting.
- Break complex tasks into smaller, verifiable steps.
- Keep track of which requirements have been implemented and which still need verification.
- Do not silently skip requirements. If a requirement cannot be fulfilled, explain why.

### 2. Validate Your Work
After implementing a change, you MUST review your work against the original request.

- Verify that every requirement has been addressed.
- Run relevant tests, builds, linters, formatters, or other validation commands when available and appropriate.
- Inspect the actual output and exit codes instead of assuming a command succeeded.
- Check for regressions, missing functionality, incomplete implementations, and unintended changes.
- For bug fixes, verify that the underlying issue is addressed rather than merely hiding its symptoms.
- For multi-step tasks, verify that every required step has been completed.
- Do not claim that something works unless you have sufficient evidence.

### 3. Fix and Revalidate
- If validation reveals a problem, investigate and fix it when possible.
- After making a fix, repeat the relevant validation steps.
- Continue until the requirements are satisfied or a genuine blocker prevents further progress.
- Do not stop after the first failed test or validation step without investigating whether it can be resolved.
- Do not repeatedly run the same failing command without a clear reason or a new hypothesis.

### 4. Completion Criteria
Before reporting a task as complete, confirm that:

- [ ] Every requested requirement has been addressed.
- [ ] Relevant tests and validation checks have passed, or their limitations are explicitly documented.
- [ ] No known issues or unfinished steps are being silently ignored.
- [ ] The implementation matches the original request and project conventions.
- [ ] Any necessary follow-up actions or unresolved blockers are clearly identified.

If a requirement cannot be verified, explicitly state that it remains unverified. Never present an unverified result as a confirmed success.

### 5. Final Response
Once the work and validation are finished, provide a concise summary containing:

1. **Implemented:** What was changed or completed.
2. **Validation:** Which checks were performed and whether they passed.
3. **Remaining issues:** Any known limitations, failed checks, unverified behavior, or blockers.

Do not report a task as fully completed while required work remains unfinished. If only part of the task could be completed, clearly distinguish completed work from remaining work.

### 6. Proportional Validation
- Choose validation methods appropriate to the scope and risk of the task.
- For simple changes, perform a focused review and the relevant lightweight checks.
- For complex changes, validate the full affected workflow and run broader tests when practical.
- For documentation-only changes, verify accuracy, completeness, and consistency.
- If automated tests are unavailable, perform the strongest reasonable alternative and disclose the limitation.
- Do not claim that tests passed if they were not run.
- Do not perform unrelated changes merely to make validation pass.
