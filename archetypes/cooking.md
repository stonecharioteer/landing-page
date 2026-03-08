---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
description: ""
tags: ["cooking"]
cuisine: ""
course: ""
vegetarian: false
cover:
  image: "images/cooking/{{ .Name }}.webp"
  alt: "{{ replace .Name "-" " " | title }}"
  relative: false
draft: true
---

## Ingredients

-

## Method

1.

## Notes

