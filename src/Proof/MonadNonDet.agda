------------------------------------------------------------------------------
-- | MonadNonDet: Models nondeterministic programs using failure and choice
-- | features
------------------------------------------------------------------------------

module Proof.MonadNonDet where

open import Proof.Monad
open import Relation.Binary.PropositionalEquality using (_≡_)

------------------------------------------------------------------
-- MonadNonDet

record MonadNonDet {M : Set → Set} (monad : Monad M) : Set₁ where
  constructor mkMonadNonDet

  open Monad monad

  field
    fail : {A : Set} → M A

    fail-left-zero : {A B : Set} {m : M B} → (fail {A} >> m) ≡ fail

    _□_            : {A : Set} → M A → M A → M A

    choice-assoc   : {A : Set} (m n p : M A) → (m □ n) □ p ≡ m □ (n □ p)

    choice-∘       : {A B : Set} (m n : M A) (k : A → M B) →
                   ((m □ n) >>= k) ≡ ((m >>= k) □ (n >>= k))
