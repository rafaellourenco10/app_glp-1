---
name: Serene Wellness & Metabolic Care
colors:
  surface: '#fbf9f6'
  surface-dim: '#dbdad7'
  surface-bright: '#fbf9f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f0'
  surface-container: '#efeeeb'
  surface-container-high: '#eae8e5'
  surface-container-highest: '#e4e2df'
  on-surface: '#1b1c1a'
  on-surface-variant: '#3e4947'
  inverse-surface: '#30312f'
  inverse-on-surface: '#f2f0ed'
  outline: '#6e7977'
  outline-variant: '#bdc9c6'
  surface-tint: '#006a63'
  primary: '#005c55'
  on-primary: '#ffffff'
  primary-container: '#0f766e'
  on-primary-container: '#a3faef'
  inverse-primary: '#80d5cb'
  secondary: '#006b5f'
  on-secondary: '#ffffff'
  secondary-container: '#6df5e1'
  on-secondary-container: '#006f64'
  tertiary: '#913200'
  on-tertiary: '#ffffff'
  tertiary-container: '#b94200'
  on-tertiary-container: '#ffe5dc'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9cf2e8'
  primary-fixed-dim: '#80d5cb'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#00504a'
  secondary-fixed: '#71f8e4'
  secondary-fixed-dim: '#4fdbc8'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005048'
  tertiary-fixed: '#ffdbce'
  tertiary-fixed-dim: '#ffb599'
  on-tertiary-fixed: '#370e00'
  on-tertiary-fixed-variant: '#7f2b00'
  background: '#fbf9f6'
  on-background: '#1b1c1a'
  surface-variant: '#e4e2df'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Manrope
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 24px
  metric-display:
    fontFamily: Manrope
    fontSize: 38px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.03em
  metric-label:
    fontFamily: Manrope
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.04em
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: Manrope
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 2rem
---

## Brand & Style

The design system is crafted for a medical and metabolic health companion specializing in GLP-1 weight-loss therapy. Its primary emotional mission is to strip away clinical anxiety, judgment, and childish gamification, replacing them with serene reassurance, medical authority, and warm domestic calm. 

The aesthetic is contemporary wellness—a refined evolution of Material 3 tailored for elevated mobile experiences. It combines warm organic off-white tones with restorative deep teals, mint accents, and tactile soft-contoured surfaces. Every screen reinforces safety, dignified self-care, and quiet confidence, transforming complex protocol tracking into an intuitive, tranquil daily routine.

## Colors

The palette establishes an empathetic, non-hospital environment while maintaining strict WCAG AA/AAA compliance for readability:

- **Primary (`#0F766E`) - Deep Teal:** Anchors the clinical credibility. Used for key structural calls-to-action, primary navigation bars, active timeline nodes, and header emblems.
- **Secondary (`#14B8A6` / `#99F6E4`) - Mint Accent:** Represents vital metabolic health, gentle progression, and successful milestones. Used in subtle progress rings, active toggle states, and soft badge backgrounds (`#99F6E4` at 20% opacity).
- **Tertiary (`#EA580C` / `#F97316`) - Warm Coral:** Strictly reserved for high-priority operational items—such as dose confirmation prompts, site-rotation reminders, expiration alerts, and missed injection notifications. Avoids panic-inducing crimson red.
- **Neutral Background (`#FAF8F5`) - Warm Off-White:** A gentle paper-like canvas that eliminates screen glare, softening the clinical edge of medical software.
- **Surface / Cards (`#FFFFFF`):** Crisp white containers floating delicately above `#FAF8F5`.
- **Text Layers:** Primary text uses Charcoal (`#1F2937`) to maximize legibility without harsh black contrast. Secondary details, timestamps, and metadata employ Slate (`#64748B`).

## Typography

The design system relies on **Manrope**, a geometric-grotesque font pairing modern clinical neutrality with warm, open counters. 

- **Numerical Hierarchy:** Dosage units (e.g., `0.5 mg`), weight tracking, and countdown days utilize `metric-display`, designed with tabular figures to eliminate jitter during value updates.
- **Contextual Anchors:** `headline-lg` and `title-md` maintain a balanced medium-to-semibold weight, avoiding intimidating bold blocks.
- **Micro-Copy & Disclaimers:** Subtext and prescription notes adhere to `body-md` and `label-sm`, always respecting accessibility contrast against the warm off-white canvas.

## Layout & Spacing

The layout is optimized for single-hand mobile interactions, based on a 390px baseline viewport:

- **Grid & Margins:** A fluid 4-column mobile grid with an outer screen margin of `1.25rem` (20px) and column gutters of `1rem` (16px).
- **Safe Area & Hit Zones:** Interactive elements observe standard iOS and Android bottom safe areas. Minimum touch targets are strictly maintained at `48x48px` to assist users experiencing injection-site discomfort or mild tremor.
- **Vertical Rhythm:** Content clusters operate on an 8pt step system. Cards, metric indicators, and dosage schedules have an internal breathing room of `1.25rem` (`space-lg`), ensuring clear separation without clinical stiffness.

## Elevation & Depth

To avoid stark clinical contrasts and aggressive skeuomorphism, the elevation model employs **Ambient Warm Shadows** combined with soft hairline borders:

- **Level 0 (Canvas):** `#FAF8F5` flat background.
- **Level 1 (Cards & Modules):** Pure `#FFFFFF` surface elevated by a dual shadow: `0px 2px 4px rgba(15, 118, 110, 0.03)` and `0px 8px 24px rgba(31, 41, 55, 0.04)`. Outlined with a sub-pixel border: `1px solid rgba(15, 118, 110, 0.08)`.
- **Level 2 (Dose Prompts & Sticky Actions):** Floats above content with `0px 12px 32px rgba(15, 118, 110, 0.10)`, creating a comforting cushion of depth.
- **Level 3 (Modals & Injection Site Selectors):** Scrim tinted with `rgba(31, 41, 55, 0.35)` with an ultra-soft bottom-sheet drop shadow `0px -8px 30px rgba(0, 0, 0, 0.08)`.

## Shapes

The shape system centers on an intentional 20px radius (`rounded-xl` in this configuration), evoking smooth river stones and comfortable handheld pens:

- **Cards & Primary Modules:** Uniform border radius of `20px` (`1.25rem`).
- **Interactive Controls (Chips & Action Badges):** Full pill-shape (`rounded-full` / 9999px) to communicate soft tactile safety.
- **Progress Trackers & Rings:** Fully rounded caps (`stroke-linecap: round`) on SVG meters and linear progress tracks, avoiding sharp right angles throughout the UI.

## Components

### Buttons
- **Primary (Injection Confirmation / Action):** 52px height, full pill radius (9999px) or `20px`. Background `#0F766E`, text `#FFFFFF`, with a subtle active press scale (`0.98`).
- **Secondary / Soft Button:** Background `rgba(15, 118, 110, 0.08)`, text `#0F766E`, font weight 600.
- **Urgent / Dose Alert Button:** Background `#EA580C`, text `#FFFFFF`, used exclusively for confirming medication administration or logging missed schedules.

### Chips & Pill Filters
- Height: 36px. Fully rounded pill format.
- Unselected: Surface `#FFFFFF`, border `1px solid rgba(100, 116, 139, 0.2)`, text `#64748B`.
- Selected: Background `#0F766E`, text `#FFFFFF`, border `1px solid #0F766E`.

### Cards & Monitoring Tiles
- Surface: `#FFFFFF`, border-radius `20px`, padding `1.25rem`.
- Features an ultra-subtle top border accent or inline circular gauge. For weight, side-effects, and titration metrics, headers present a muted label alongside an icon badge in `#99F6E4`.

### Dosage & Injection Tracker
- Features a visual body map or carousel selector indicating rotation sites (Abdomen, Thigh, Upper Arm).
- Completed doses use a soft mint checkmark indicator (`#14B8A6`). Imminent doses are framed in warm coral (`#EA580C`).

### Form Inputs & Steppers
- Height: 52px. Radius: `16px`.
- Inactive state: Surface `#FFFFFF`, border `1.5px solid rgba(100, 116, 139, 0.15)`.
- Focused state: Border `1.5px solid #0F766E` with a subtle focus halo `0 0 0 3px rgba(20, 184, 166, 0.15)`.
- Numeric steppers (for setting unit clicks or dosage adjustments): tactile wide buttons with minimum 48px hit areas.