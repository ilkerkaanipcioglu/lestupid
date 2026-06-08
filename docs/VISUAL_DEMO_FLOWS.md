# LesTupid Visual Demo Flows

This document is the visual demo brief for humans and AI agents. Every app can
have its own screen, but the first shared visual layer is LesTupid Go:
`les_go` shows the ecosystem as contextual flows.

## Visual Rule

Fast things feel fast. Flowing things flow. Static things stand still. Crowded
places feel dense. Calm places breathe. Risky things look risky. Every product
keeps its own mood.

## Ecosystem Map

```mermaid
flowchart TB
  User["User / Identity"] --> Go["LesTupid Go\nContext shell"]
  Go --> Wait["Les Wait\nQueues and timing"]
  Go --> Poke["Les Poke\nQuests and memory"]
  Go --> Match["Les Match\nOpt-in people/service matching"]
  Go --> Commerce["Les Commerce\nOffers, listings, checkout"]
  Go --> Contacts["Les Contacts\nPrivate CRM memory"]
  Go --> Harmonica["Les Harmonica\nSafe contact"]
  Go --> Care["Les Care\nSafe info and routing"]
  Go --> Travel["Les Travel\nVisa, stay and trip safety"]
  Go --> AI["Les AI / AgentAndBot\nLabeled agents"]
  Go --> Cert["Les Certification\nTrust and proof"]
```

## Campus Day

```mermaid
flowchart LR
  CheckIn["Check in: campus"] --> Topics["Nearby topics\nattention-limited"]
  Topics --> Queue["Les Wait\ncanteen queue"]
  Topics --> Quest["Les Poke\nfocus quest"]
  Topics --> MatchPrompt["Les Match\nopt-in prompt"]
  Topics --> Kadro["KADRO agent\nstudy or sponsor help"]
  Queue --> Feed["Go opportunity feed"]
  Quest --> Feed
  MatchPrompt --> Feed
  Kadro --> Feed
  Feed --> Contacts["Les Contacts\nprivate memory"]
```

## Commerce And Product Memory

```mermaid
flowchart LR
  Product["Product/listing/card"] --> Commerce["Les Commerce\nprice, terms, checkout"]
  Commerce --> Receipt["Order/receipt/refund source"]
  Receipt --> Contacts["Les Contacts\nprivate product memory"]
  Contacts --> Go["Go reminder/follow-up card"]
  Contacts --> Cert["Optional trust evidence\nonly after consent"]
```

## Kenya Student To Turkiye

```mermaid
flowchart LR
  Student["Kenyan student\nNairobi geography"] --> Intent["Trip intent\nKenya -> Turkiye"]
  Intent --> Visa["Official visa/source card\nlast checked date"]
  Intent --> Docs["Document checklist\nschool/invite/funding/stay"]
  Docs --> Stay["Safe stay options\nrisk labels"]
  Stay --> Contact["Trusted contacts\nHarmonica handoff"]
  Contact --> Arrival["Go arrival mode\nairport/campus/city"]
  Arrival --> Memory["Contacts private\ntravel memory"]
```

## Holiday Risk Guard

```mermaid
flowchart LR
  Trip["Holiday intent"] --> Budget["Budget and return guardrail"]
  Budget --> Stay["Booking/stay verification"]
  Stay --> Risk["Tourist trap risk cards"]
  Risk --> SafeAlt["Certified alternatives"]
  Risk --> Contact["Trusted contact / emergency handoff"]
  SafeAlt --> Memory["Private trip memory"]
```

## Item Otel

```mermaid
flowchart LR
  Send["Send item"] --> Custody["Item Otel custody"]
  Custody --> Care["Care / condition log"]
  Care --> Listing["Rent or sell option"]
  Listing --> Commerce["Commerce listing"]
  Custody --> Recall["Recall item"]
  Custody --> Contacts["Private asset memory"]
  Custody --> Cert["Custody proof / trust"]
```

## Safe Contact

```mermaid
flowchart LR
  Signal["Nearby / match / venue signal"] --> Consent["Explicit contact consent"]
  Consent --> Alias["Pairwise alias"]
  Alias --> Harmonica["Les Harmonica encrypted contact"]
  Harmonica --> Revoke["Revoke / report"]
  Alias --> Cert["Optional pseudonymous trust"]
```

## Care And Safety

```mermaid
flowchart LR
  Question["Care question"] --> Boundary["Safety boundary\nno diagnosis/prescription"]
  Boundary --> Info["Certified info card"]
  Info --> Route["Clinic/pharmacy route"]
  Route --> Wait["Les Wait appointment/queue"]
  Route --> Contacts["Private health follow-up memory"]
```

## Demo Surfaces

| Surface | What To Show | File |
| --- | --- | --- |
| Visual Flow Gallery | Cross-app storyboard cards | `les_go/src/main.tsx` |
| Go Hub | Place, mode, nearby topics, feed cards | `les_go/src/main.tsx` |
| Les Wait | Queue ticket and arrival window | `les_go/src/main.tsx`, `les_wait/waiting.html` |
| Les Poke | Quest map and XP | `les_go/src/main.tsx`, `Les_poke/apps/mobile/App.tsx` |
| Les Match | Opt-in profiles and chat handoff | `les_go/src/main.tsx` |
| Item Otel | Storage, care, listing and recall | `les_go/src/main.tsx` |
| Les Contacts | CRM timeline and context spaces | `les_go/src/main.tsx`, `les_contacts/README.md` |
| Les Harmonica | Proximity, alias, secure contact | `les_go/src/main.tsx` |
| Les AI | KADRO agent console | `les_go/src/main.tsx` |
| Certification | Selective trust and ZKP mock | `les_go/src/main.tsx` |
