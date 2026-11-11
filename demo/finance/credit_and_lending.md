# Credit and Lending

Credit and lending are a classic
explore-vs-exploit/multi-armed bandit setting,
with some intrinsic stumbling blocks
(some unique, some universal).

## Stumbling Blocks

- **Macro**:
  There's basically never enough representative and reliable data from rare regimes
  to actually empirically distinguish the relative suitability of things like
  logit vs probit regression models for real-world problems.
  First of all, rare regimes are, well, rare.
  Second of all, when they do happen:
  - Everybody starts behaving differently
    (including lenders who stop originating low-FICO loans,
    whose default rates therefore become unobservable);
  - Data quality suffers as people are busy trying to work out deals
    rather than maintain excellent ETLs and tables.

## Hope

There is hope!

First of all, I am reminded of this
[hacker koan](https://simple.wikipedia.org/wiki/Hacker_koan#Enlightenment):
> A novice was trying to fix a broken Lisp machine by turning the power off and on.
>
> Knight, seeing what the student was doing, spoke sternly:
> "You cannot fix a machine by just power-cycling it
> with no understanding of what is going wrong."
>
> Knight turned the machine off and on. The machine worked.

Second of all, I am reminded of an old CTO who rebranded
"funding unprofitable loans"
as "paying for training data".
Experience and lessons, right?
