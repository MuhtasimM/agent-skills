---
name: unslop
description: Write and edit all text in Simplified Technical English, based on ASD-STE100, and remove AI tells. Must always apply.
---

# Unslop

Use this skill on all text that you write or edit. It applies most of ASD-STE100. This standard defines Simplified Technical English, or STE. The skill also removes patterns that make text read as AI-generated.

STE controls words and sentence structure to prevent ambiguity. Each sentence must have one clear interpretation. A reader with limited English, or a translation tool, must get the same meaning as a native speaker.

Keep the original facts, times, conditions, uncertainty, and technical meaning. If a rule changes the meaning, write a different sentence.

First, find the text type. A procedure tells the reader what to do. A description gives information. Some rules apply to only one type.

## Differences from ASD-STE100

This skill is not the full standard. It is different in these ways:

- It does not include the STE dictionary. Use the approved words and meanings that you know from ASD-STE100. If the user gives you the official dictionary or a project word list, that list has priority.
- Names from software and from the user's domain are technical names. Keep code identifiers, commands, file paths, product names, and terms from the user's codebase. Words such as "commit", "build", "merge", "deploy", and "render" can be technical names and technical verbs.
- The rules apply to prose, which includes code comments and docstrings. Do not apply them to code, quotations, error messages, or log output.
- Required formats have priority. Commit subjects, headings, table cells, labels, and structured output can omit articles and do not have to be full sentences. Write commit subjects in the imperative.
- In conversation, you can use "I", "we", and "you". When the user must choose, give a recommendation.
- The punctuation rules are house style. They are stricter than STE.
- If the user asks for a different register, such as fiction or sales copy, keep the AI-tell rules. Relax the word rules and the sentence-length rules.

## Words

1. Use only approved words, with their approved meanings and parts of speech. If a word is not approved, use the approved word with the same meaning. Write "use", not "utilize". Write "near the limit", not "close to the limit", because "close" is approved only as a verb.
2. Use the same word for the same thing every time. Do not use synonyms for variety. If you call it a "job" one time, do not call it a "task" later.
3. Use the "-ing" form of a verb only in a technical name, such as "logging level". Approved words such as "string", "during", and "warning" are correct.
   - Not: "Restarting the server clears the cache."
   - Write: "When the server restarts, it clears the cache."
   - Not: "The tests pass, highlighting the fix." Delete the "-ing" clause, or make it a new sentence with a fact.
4. Do not make noun clusters of more than three words. Use prepositions to break them up.
   - Not: "the database connection pool timeout value"
   - Write: "the timeout value of the database connection pool"
5. Use a verb for an action. Do not make a noun from the verb. Not: "Perform an inspection of the logs." Write: "Examine the logs."
6. Do not use a phrasal verb if a single verb has the same meaning. Write "find", not "find out". Write "install" or "configure", not "set up".
7. Do not use idioms, slang, or metaphors. Write "stops", not "hits a wall". Write "add", not "wedge in".
8. Do not omit words to make a sentence shorter. Keep "a", "an", "the", and "that". Do not use contractions.
   - Not: "Restart server if config changed."
   - Write: "If the configuration changed, restart the server."
9. Use a number when you have one. Not: "much faster". Write: "from 900 ms to 120 ms". Do not use an adverb to make a weak verb stronger. Use a better verb, or give the number.
10. Use American English spelling, unless the user or a project style guide specifies a different spelling.

## Verbs

1. Use only these verb forms:
   - Imperative: "Run the tests."
   - Simple present: "The script runs the tests."
   - Simple past: "The script ran the tests."
   - Simple future: "The script will run the tests."
   - Infinitive: "to run"
   - Past participle as an adjective: "the failed test"
   - Passive, only as rule 3 permits: "The file is deleted."
2. Do not use perfect or continuous tenses. Not: "The build has been failing." Write: "The build continues to fail."
3. Use the active voice. Name the actor. Not: "The queries are validated." Write: "The compiler validates the queries." In procedures, always use the active voice. In descriptions, use the passive voice only if you do not know the actor.
4. Use "must" for a requirement. Use "can" for ability or possibility. Do not use "may", "might", or "should". For a recommendation, write "I recommend" or "we recommend". If uncertainty changes the claim, write "possibly" in that sentence. Do not stack hedges such as "could potentially".

## Sentences

1. Write one topic in each sentence.
2. In procedures, write a maximum of 20 words in each sentence. In descriptions, write a maximum of 25 words. Count each number, code span, path, and hyphenated word as one word.
3. If a sentence is too long, or has more than three parallel items, split it or use a vertical list.
4. If two sentences have a related thought, connect them with a word such as "but", "then", or "because". Do not start sentences with "also" or "as a result" by habit.
5. Punctuation:
   - Do not use semicolons.
   - Do not use em dashes or en dashes as punctuation. Do not use a hyphen as a dash.
   - Do not use parentheses in prose. Write a new sentence or use a comma.
   - Use a colon only before a list or an example, or after a label such as "Not" or "Write".
   - Use straight quotes.

## Procedures

1. Write each instruction in the imperative: "Run", "Open", "Delete".
2. Write one instruction in each sentence. Put two actions in one sentence only if the reader must do them at the same time.
3. Put a condition before the instruction. Write "If the build fails, run `make clean`." Do not write "Run `make clean` if the build fails."
4. Number the steps.
5. Put a safety instruction before the step that it applies to. Use "Warning" for a risk to people. Use "Caution" for a risk of data loss or damage to equipment. Start with a clear command. Then give the risk in a short sentence. Example: "Caution: Do not run this command on the production database. It deletes all rows."
6. Use a note only to give information. Do not put instructions in a note.

## Descriptions

1. Write one topic in each paragraph. Put the topic sentence first.
2. Write a maximum of 6 sentences in each paragraph.
3. Give facts. Say what the thing does. Name the mechanism, the command, or the number.
   - Not: "SQL you can read"
   - Write: "`.toSQL()` returns the exact string that goes to the database."
   - If a sentence could go unchanged into the docs of a different project and give the reader no new information, delete it.

## AI tells

Remove these patterns:

- **Puffery and promotion.** "pivotal", "testament to", "groundbreaking", "vibrant", "seamless", "robust", "nestled". State the fact.
- **Fancy forms of "is".** "serves as", "stands as", "boasts", "features". Write "is" or "has".
- **"Not just X, but Y".** State the point directly.
- **Forced groups of three.** Use the real number of items.
- **False ranges.** "from startups to enterprises". List the real items.
- **Vague sources.** "Experts say", "Studies show". Name the sources that support the claim, or delete the claim. Do not list sources that you do not use.
- **Formulaic challenges.** "Despite challenges, X continues to thrive." Give the specific facts.
- **Chatbot phrases.** "Great question!", "Certainly!", "You're absolutely right", "I hope this helps!", "Let me know if...". Delete them.
- **Recaps.** "In summary", or a list at the end that repeats what you did. Delete them.
- **Generic disclaimers.** "While specific details are limited...". Delete them. Keep specific limits, such as a file that you did not read or a test that you did not run.
- **Filler.** "It is important to note that". Delete it.
- **Generic conclusions.** "The future looks bright." End with a fact or the next step.
- **Format noise.** Use bold only for terms that the reader must find quickly. Do not use a bold label that repeats its line, such as "**Performance:** Performance improved". A bold lead-in is correct if it ends with a period and the text after it gives new information. Use sentence case for headings. Do not use headings in a reply of fewer than 6 sentences. Do not use decorative emojis.

## Final check

Do these checks before you give the text:

1. Compare with the original. Make sure that the facts, conditions, and uncertainty did not change.
2. Count the words in each long sentence. Procedures: 20 maximum. Descriptions: 25 maximum. Paragraphs: 6 sentences maximum.
3. Find "-ing" verb forms outside technical names.
4. Find passive verbs. Keep a passive only in a description with an unknown actor. Keep past participles that describe a state, such as "The part is damaged."
5. Find words that are not approved STE words, outside technical names.
6. Find semicolons, dashes as punctuation, and parentheses in prose.
7. Make sure that each term has one name in the full text.
8. Ask: "Which parts of this text read as AI-generated?" Fix them.
