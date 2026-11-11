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
  - First of all, rare regimes are, well, rare.
  - Second of all, when they do happen:
    - Everybody starts behaving differently
      (including lenders who stop originating low-FICO loans,
      whose default rates therefore become unobservable).
      - This points at a broader stumbling block, too:
        All historical performance data comes from a highly-filtered/selected population,
        i.e. only the loans somebody else or you were willing to fund at the time.
        You might scan historical tapes from past crises and conclude that
        FICO is not predictive of defaults during stress periods,
        simply because nobody was dumb enough to fund the low-FICO loans at the time.
    - Data quality suffers as people are busy trying to work out deals
      rather than maintain excellent ETLs and tables.
- **Adverse Selection**:
  This is the "market for lemons" problem:
  Regardless of what you approve or aim to approve,
  offer takeup will not be uniformly random
  if you don't charge market-reasonable APRs.
  To wit: Say you accurately and precisely predict
  ex-ante PD, LGD, and EAD for "FICO 700" borrowers to be low.
  You cannot increase your returns simply by jacking up APRs there!
  Why? Because:
  - Truly "safe" borrowers are likely to be recognized as such
    and offered lowered APRs on the market.
    Most people do _some_ amount of "shopping around",
    so the truly safe borrowers will simply opt for those better offers,
    leaving you with only risky borrowers.
  - Any remaining diligent borrowers with high intent to repay
    will be scared off by the interest burden.
    That leaves only risky borrowers
    who could not eke a single good offer out of the market
    but who don't care because they don't plan to repay anyway.
- **PDR (Price-Dependent Risk)**:
  Even a borrower with high intent to repay
  who nevertheless accepts a high-interest loan
  may be "knocked off the tightrope"
  by the high monthly payment itself.
  And once they've faltered on repaying your loan,
  they may prefer to charge off completely
  (at the cost of burning their relationship with you altogether)
  so they can focus on lenders
  where they don't yet have derogatory marks.
- **The Optimizer's Curse**:
  When you score ex-ante risk,
  the most extremely safest-scoring applicants
  are precisely the ones most likely to
  have gotten "lucky"
  (been the beneficiaries of favorable noise
  in the modeling/scoring process)
  rather than to be truly safe.
  Thus, even if your loss estimate is unbiased over the whole population,
  by approving only the safest-scoring applicants,
  you mechanically force your loss estimate to be biased too low.
- **Regression to the Mean**:
  A similar idea applies to repeat borrowers.
  Say you decide to approve _everyone_
  then re-approve only the very best-performing borrowers
  from the first round when they reapply.
  Those are precisely the borrowers most likely to have
  gotten lucky by random chance.
- **The Auction-Winner's Curse**:
  Say you offer an APR and the applicant accepts.
  You immediately experience buyer's remorse.
  "Gee", you wonder, "how risky was he after all,
  that nobody else was willing to offer him a better APR?".

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
