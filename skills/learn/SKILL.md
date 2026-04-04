---
name: learn
description: Use when diving deep into an unfamiliar domain, working through a backlog of saved materials, or preparing to write a research article.
version: 1.0.0
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - WebSearch
  - AskUserQuestion
---

# Learn: From Raw Materials to Published Output

Deep learning structured like engineering work. Six phases, each with a clear role for you and a clear role for AI.

The measure of learning is not how much you read. It is how much you produce. Input that never becomes output is just consumption.

AI is a tool in this process, not a replacement for your thinking. Never let AI read for you, decide for you, or write in your voice without your direction. The moment you outsource the thinking, the learning stops.

## Phase 1: Collect

Gather only high-quality primary sources. For a technical domain this means: recent papers that introduced key ideas, official model and product blogs from the labs, posts from the people who built the thing, university course materials from the last two years, and canonical "build it from scratch" repositories.

Not summaries. Not explainers. Not "top 10 things you need to know." Sources.

For each source: download it, convert to Markdown, clean, and file it into a structured research directory organized by sub-topic.

```bash
# Convert a URL to Markdown and save it
# Use /read for individual pages
# For bulk work: automate with curl + r.jina.ai or a download script
```

The goal at the end of Phase 1: a local, organized repository of raw materials.

## Phase 2: Digest

Work through the materials yourself. For each piece:

- If you understand it: read it fully, keep what is good, delete what is not.
- If you do not understand it: ask Claude to explain the specific part that is unclear. For dense technical content, ask for a Chinese translation. Do not ask for a summary of the whole thing.
- If there is code: run it locally if possible. If not, read the structure and understand what each part does.

At the end of this phase, cut roughly half of what you collected. If you cannot decide what to cut, the material was not strong enough.

For key concepts, try cutting across multiple angles: how did this idea evolve historically? What is the opposite claim? What does it look like in practice vs. in theory? What breaks if you remove it? This kind of multi-dimensional interrogation builds a real mental model, not just a definition.

Claude's role here: explain, translate, answer specific questions. Not summarize or evaluate on your behalf.

## Phase 3: Outline

Once you have a working mental model of the domain, write an outline for the article.

The outline must answer: what do you want to say, and what does your reader need to know to follow it? These are not the same question. Know your reader's level and write for that level, not above it.

For each section in the outline: note the source materials it draws from. If a section has no sources, either it does not belong in the article or you need to find the source.

The outline is a contract with yourself. Do not start filling it in until it is solid.

## Phase 4: Fill In

Work through the outline section by section. This is the repetition phase: revisiting material you already processed, synthesizing it into continuous prose, filling gaps as you find them.

You will end up with a long, somewhat rambling draft. That is correct. Do not edit while writing. Get it all down first.

## Phase 5: Refine with AI

Now hand the draft to Claude with a specific brief:

- Remove redundant and verbose passages without changing the meaning or your voice
- Flag places where the argument does not flow
- Identify gaps: places where a concept is used before it is explained, or where a claim needs a source

Work through the suggestions yourself. Accept, reject, or modify each one. Do not accept blindly. This phase often surfaces things you missed in Phase 2, which means more learning.

## Phase 6: Self-Review and Publish

Read the entire article yourself, not with AI. Read it as your target reader would: linearly, without jumping back.

Mark everything that feels off: unclear sentences, abrupt transitions, sections that drag. Fix them. Read again. Two full passes is the minimum.

When it reads clean from start to finish: publish it.

One concern to set aside: "what if no one reads it." If the content has substance, readers will find it. That concern is not a reason to skip publishing. It is a reason to make sure the content has substance.

## At Any Phase: What to Ask Claude

| Situation | Useful prompt |
|-----------|---------------|
| Something is unclear | "Explain [concept] to someone who knows [adjacent field] but not this one" |
| Dense technical paper | "Translate this section to Chinese, keep technical terms in English" |
| Evaluating a source | "What is the main claim here, and what evidence supports it?" |
| Outline feedback | "What is missing from this outline for a reader who knows [level]?" |
| Draft refinement | "Cut the redundancy from this section without changing my voice or meaning" |
| Gap detection | "What would a reader need to know before reading this section?" |

## Red Lines

- Do not ask Claude to summarize a paper you have not read. Read it yourself.
- Do not let Claude write sections of the article from scratch. Fill them in yourself, then refine.
- Do not skip Phase 6 because "AI already reviewed it." AI read it for fluency. You need to read it for truth.
