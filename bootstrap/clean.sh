#!/bin/bash

set -ex

git config unset --global core.pager delta || true
git config unset --global interactive.diffFilter 'delta --color-only' || true
git config unset --global delta.navigate true || true
git config unset --global delta.line-numbers true || true
git config unset --global delta.side-by-side false || true
git config unset --global merge.conflictStyle zdiff3 || true
