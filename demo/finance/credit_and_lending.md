# Credit and Lending

Credit and lending are a classic
explore-vs-exploit/multi-armed bandit setting,
with some intrinsic stumbling blocks
(some unique, some universal).

## Stumbling Blocks

Pitfalls range
from data and modeling
to underwriting and approval/offer policies
to pricing/terms and competition.

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
- **The Optimizer's Curse**:
  When you score ex-ante risk,
  the most extremely safest-scoring applicants
  are disproportionately likely to
  have gotten "randomly lucky"
  (been the beneficiaries of favorable noise
  in the modeling/scoring process)
  rather than to be truly that safe.
  Thus, even if your loss estimate is unbiased over the whole population,
  by approving only the safest-scoring applicants
  (and thereby cutting out most of the "randomly unlucky" ones),
  you mechanically force your loss estimate to be biased too low
  on the population you select.
  - Imagine everyone has a true PD of 10%.
    Your data and training methodology are
    of course susceptible to noise,
    so they produce an imperfect model
    which says that half the people are 0%
    and half the people are 20%.
    On average over the whole population,
    your model looks indeed unbiased
    because its errors balance out
    (although in this oversimplified example,
    it would be irresponsible not to catch
    _conditional_ miscalibration,
    i.e. measure the routine check whether,
    empirically, `Pr[D = 1 | model_p = p] = p`).
    And its AUC/Gini are neutral,
    so there's no obvious alarm bell about overfitting in particular
    (although, again, in real life,
    nobody would deploy a coin-flip model to PROD).
    Yet, if you use its scores to
    offer loans only to the "model 0%" people,
    you will be badly surprised
    (in the unpleasant direction)
    when realized losses come in at 10%.
    - Methodological note:
      I have found in the past that,
      not always, but sometimes,
      a bit of shrinkage to the mean
      (or to some magical constant background default rate)
      helps with this.
- **Regression to the Mean**:
  A similar idea applies to repeat borrowers.
  Say you decide to approve _everyone_
  then re-approve only the very best-performing borrowers
  from the first round when they reapply.
  Those are precisely the borrowers most likely to have
  gotten lucky by random chance.
  - This doesn't even account for the fact that,
    defaults being relatively uncommon,
    observing _no default_ may not be very persuasive evidence
    that the borrower's quality is any better than you initially thought
    (although, asymmetrically, observing _a default_ may be
    persuasive evidence that the borrower's quality is
    _worse_ than you initially thought),
    or that the very act of repeat-borrowing is associated with credit-seeking,
    which may itself be associated with financial weakness or deterioration.
- **Price Sensitivity, Demand Elasticity, and Adverse Selection**:
  This is the "market for lemons" problem:
  Regardless of what you approve or aim to approve,
  offer takeup will not be uniformly random
  if you don't charge market-reasonable APRs.
  To wit: Say you accurately and precisely predict
  ex-ante PD, LGD, and EAD for "FICO 825" borrowers to be low.
  You cannot increase your returns
  (even if you think you can tolerate the cost of reducing total won volume)
  simply by jacking up APRs there!
  - Why? Because:
    - Truly "safe" borrowers are likely to be recognized as such
      and offered lower APRs on the market.
      Most people do _some_ amount of "shopping around",
      so the truly safe borrowers will simply opt for those better offers,
      leaving you with only risky borrowers.
    - Any remaining diligent borrowers with high intent to repay
      will be scared off by the interest burden.
      That leaves only risky borrowers
      who could not eke a single good offer out of the market
      but who don't care because they don't plan to repay anyway.
  - The result: Borrowers who accept high-vs-market APRs tend to be the ones who
    either (a) are truly very risky and so that's basically the best deal they see,
    or (b) aren't planning to repay and so don't care.
    If you deem a borrower safe, offer a high-vs-market APR anyway, then observe it taken,
    that should change your posterior estimate about that borrower's true riskiness.
  - The simplistic sliding policy: Within a given true risk band and term:
    - If you offer 0% APRs,
      everyone will flock to you
      (including a lot of peaches who would otherwise
      never have participated in the market at all);
    - If you offer market-like APRs,
      you can probably expect
      a market-like mix of peaches and lemons;
    - If you offer 100% APRs,
      you may be setting yourself up for
      a disappointing haul of 100% lemons.
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
- **The Auction-Winner's Curse**:
  Say you offer an APR and the applicant accepts.
  You immediately experience buyer's remorse.
  "Gee", you wonder, "how risky was he after all,
  that nobody else was willing to offer him a better APR?".
  Importantly, this is a _separate mechanism_
  from the adverse-selection effect mentioned above!
  Even if there's only one borrower
  and he's guaranteed to accept the loan,
  the fact that you won the auction
  (offered the lowest APR)
  suggests that you had the most favorable view of his riskiness,
  which (in some settings, especially against very smart competitors
  whose main weakness is noisy data or modeling)
  may raise concerns about whether your view was mistaken.

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
