# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NurseryConnect is an iOS app for early childhood education settings (nurseries/preschools). It enables keyworkers to document children's daily activities, development milestones, incidents, and wellbeing, and communicate with parents. Built with SwiftUI + SwiftData, targeting iOS 16+, no external dependencies.

## Build & Development

This is an Xcode project. Open `NurseryConnect.xcodeproj` in Xcode 16.3+.

- **Build**: `Cmd+B` in Xcode, or `xcodebuild -scheme NurseryConnect -destination 'platform=iOS Simulator,name=iPhone 16'`
- **Run**: `Cmd+R` in Xcode
- **Test**: `Cmd+U` in Xcode, or `xcodebuild test -scheme NurseryConnect -destination 'platform=iOS Simulator,name=iPhone 16'`
- **Run single test**: In Xcode, click the diamond next to the test function; or `xcodebuild test -scheme NurseryConnect -only-testing:NurseryConnectTests/TestClassName/testMethodName`

No package manager (SPM/CocoaPods) is used — pure Apple frameworks only.

## BRAND & DESIGN RULES

These rules apply to every single screen and component in the app. Never deviate from them.

The app has three brand colours. Yellow (#FAF29B) is used for all screen backgrounds. Purple (#868EF1) is used for all primary buttons, active tab bar items, section headers, and selected states. Pink (#FFA6F2) is used for allergen badges, the SOS button, alert highlights, and accent elements. All text throughout the entire app must be black (#000000). All card surfaces and form fields must be white (#FFFFFF).

Define these as static Color extensions so they can be referenced as Color.brandYellow, Color.brandPurple, and Color.brandPink throughout the codebase. Include a hex string initialiser on Color to support this.

Every screen must use the yellow background colour ignoring the safe area. White rounded cards (corner radius 20, subtle drop shadow) sit on top of the yellow background. Never use a plain list background — always use cards on yellow.

All primary action buttons must be purple with white text, full width, corner radius 14, and 16pt padding vertically. Define this as a reusable ViewModifier called PurpleButton.

Define a reusable CardStyle ViewModifier that applies white background, corner radius 20, and a soft drop shadow. Every card in the app uses this modifier.

Typography uses SF Pro Rounded for titles and button labels, and SF Pro for body text. Headings are 22pt semibold. Card titles are 17pt semibold. Body text is 15pt regular. Captions and badge labels are 12pt medium. All text is black.

Force the entire app to display in light mode only. Apply preferredColorScheme(.light) at the root level.

---

## FILE & FOLDER STRUCTURE

Organise the project into the following folders. Create each folder and place the correct files inside.

The App folder contains NurseryConnectApp (the entry point), AppRootView (the screen router), and SeedData (the sample data loader).

The Models folder contains four files: Keyworker, Child, DiaryEntry, and IncidentReport.

The ViewModels folder contains four files: AuthViewModel, ChildListViewModel, DiaryViewModel, and IncidentViewModel.

The Views folder is divided into subfolders: Auth (LoginView), Splash (SplashScreenView), Dashboard (KeyworkerDashboardView), Children (ChildListView and ChildProfileView), Diary (DiaryTimelineView and DiaryLogCard), Incident (IncidentListView, IncidentFormView, and BodyMapView), SOS (SOSButton and SOSView), and Shared (AllergenBadgeView, ConsentBannerView, and BrandComponents).

The Tests folder contains NurseryConnectTests for unit tests and NurseryConnectUITests for UI tests.

---

## DATA MODELS

All models use the SwiftData @Model macro and are stored in a single ModelContainer.

**Keyworker** stores the id (UUID), full name, email, password as plain text (acceptable for MVP only), and room name.

**Child** stores the id (UUID), full name, preferred name, date of birth, room name, the assigned keyworker's UUID (this is the GDPR data minimisation field — it controls which children each keyworker can see), a boolean for photo consent, an array of allergen strings, an array of dietary restriction strings, and medical notes. It has cascade-delete relationships to diary entries and incident reports. Include a computed property that returns the child's initials (first letter of each name part) and another that returns their age in years.

**DiaryEntry** stores the id (UUID), child id, keyworker id, and a timestamp that is set automatically to the current date and time at the moment of creation — this value must never be editable by the user. It stores the entry type as an enum with cases for activity, meal, nap, nappy, mood, arrival, and departure. Each case has an associated SF Symbol name and a colour (activity = purple, meal = pink, nap = blue, nappy = green, mood = orange, arrival = teal, departure = gray). The model also stores optional fields for every log type in a single flat structure: for activity entries it stores activity name, EYFS area, and duration in minutes; for meal entries it stores meal type, foods offered, consumption level, fluid volume in millilitres, fluid type, and a boolean for allergen acknowledged; for nap entries it stores start time, end time, and sleep position; for nappy entries it stores nappy type and a boolean for concerns noted; for mood entries it stores the mood rating. All entries also have a notes string. Include a computed summary text property that returns a short human-readable description based on the entry type.

**IncidentReport** stores the id (UUID), child id, child name as a string (denormalised for display), keyworker id, and a timestamp set automatically at creation — never editable. It also stores location, category (using an enum with six cases: Accident Minor, Accident First Aid, Safeguarding Concern, Near Miss, Allergic Reaction, Medical Incident), a description, immediate action taken, witness names as a comma-separated string, body map annotation data encoded as a Data blob, status as a string (either "draft" or "submitted"), and a boolean for whether SOS was activated during this incident. Body map annotations are a Codable struct with an id, normalised x and y coordinates (0.0 to 1.0), the body side (front or back), and a text note.

---

## SEED DATA

Create a SeedData struct with a static method that inserts sample data when the app first launches. Only insert if the database is empty — check this before inserting.

Insert one keyworker named Sarah Mitchell with email keyworker@littlestars.co.uk, password Stars2024!, and room name Room Sunflower. Store her UUID as a constant that other parts of the app reference (SeedData.keyworkerId).

Insert three children all assigned to Sarah's keyworker ID. Emma Johnson (preferred name Emma, age approximately 3, room Sunflower, photo consent granted, allergens: Milk and Eggs). Oliver Smith (preferred name Ollie, age approximately 4, room Sunflower, photo consent NOT granted — this triggers the consent banner, allergen: Nuts). Lily Chen (preferred name Lily, age approximately 2, room Sunflower, photo consent granted, no allergens).

Insert three sample diary entries for Emma: an arrival entry at 8:30am, a breakfast meal entry at 8:45am (food offered: porridge and banana, consumption: most, fluid: 150ml milk, allergen acknowledged: true), and a nap entry from 12:00pm to 1:15pm (sleep position: back).

Insert one sample incident report for Oliver with category Accident Minor, location outdoor play area, a brief description about tripping on grass and grazing his knee, immediate action of applying antiseptic and a plaster, witness name Jane Peters, and status submitted.

---

## NAVIGATION FLOW

The app has a linear entry sequence and then a tab-based main structure.

AppRootView manages three phases using a state variable: splash, login, and main. It switches between SplashScreenView, LoginView, and MainTabView based on the current phase. Transitions between phases use a smooth easeInOut animation.

MainTabView is a TabView with two tabs: My Children (using a family SF Symbol) and Incidents (using an exclamationmark shield SF Symbol). The tab bar accent colour is purple. A persistent SOS floating button sits above the tab bar in a ZStack overlay — it must be visible on every screen including during navigation pushes. The SOS button triggers a full-screen cover showing SOSView.

Inside the My Children tab, the navigation stack goes from ChildListView to ChildProfileView to DiaryTimelineView. The diary log card appears inline within DiaryTimelineView — it is not a separate screen.

Inside the Incidents tab, the navigation stack goes from IncidentListView to IncidentFormView. The body map appears inline within IncidentFormView — it is not a separate screen or sheet.

Use NavigationStack throughout. Do not use the deprecated NavigationView.

---

## SCREEN-BY-SCREEN INSTRUCTIONS

---

### Splash Screen

The background is yellow filling the entire screen including safe areas. The NurseryConnect logo image is centred on screen at 180 by 180 points. Below the logo, the word "Nursery" appears in purple bold 32pt SF Pro Rounded, and directly below it the word "Connect" appears in pink bold 32pt SF Pro Rounded.

When the screen appears, animate the logo and text in together using a spring animation with a response of 0.6 and damping fraction of 0.55. They should start at 30% scale, zero opacity, and 40 points below their final position, then spring into place.

After 0.8 seconds, run a gentle pulse: scale the logo up to 107% and back, repeated twice with auto-reverse.

After 2.5 seconds, fade everything out by animating opacity to zero and scale to 115%, then call the completion handler to transition to the login screen.

---

### Login Screen

The background is yellow. Display the NurseryConnect logo at 100 points, centred near the top of the screen with a spring entrance animation on appear.

Below the logo, show a white card using the CardStyle modifier. Inside the card, show the heading "Welcome back 👋" in the screen header font. Below that, show an email text field with an envelope SF Symbol as a leading icon. Below that, show a password secure field with a lock SF Symbol as a leading icon. Both fields have a white background, rounded corners of 12, and a purple border when focused.

Pre-populate the email field with keyworker@littlestars.co.uk and the password field with Stars2024!.

If the user enters wrong credentials and taps Sign In, a pink error banner slides in from the top of the card with the message "Incorrect email or password. Please try again." Use a move and opacity transition. Do not use an alert dialog — keep the error inline.

The Sign In button uses the PurpleButton modifier. When tapped with correct credentials, call the success handler to transition to the main tab view. Use AuthViewModel to manage credentials and error state.

---

### Dashboard (shown at the top of the Child List screen)

Rather than a separate tab, show dashboard content as the header section of ChildListView, above the child list cards.

Show a greeting "Good morning, Sarah 🌟" in the app title font. Below that, show a purple welcome card with white text reading "Room Sunflower · 3 children today" and "2 logs submitted today".

Show a horizontal row of three white pill-shaped stat cards: one showing the total diary logs submitted today, one showing the count of open incidents, and one showing the count of children with active allergen alerts. These are derived from live SwiftData queries.

Show a "My Children" section with a horizontal scroll view of compact child avatar cards. Each card shows a coloured circle with the child's initials in white, their name in bold, and a pink allergen badge if they have any allergens. Tapping a card navigates to that child's profile.

Show a "Recent Activity" section with the last three diary entries across all assigned children as white cards, each with a coloured left border matching the entry type colour.

---

### Child List Screen

The background is yellow. Show a "My Children" heading. Show a search text field with a magnifying glass icon — it filters the list in real time by child name.

Query children from SwiftData filtered to only those where the assigned keyworker UUID matches SeedData.keyworkerId. This is the data minimisation enforcement.

Show each child as a white card using CardStyle. Each card has a coloured circle on the left showing the child's initials with a purple background and white text. In the centre, show the child's full name in card title font and their room name in caption font in gray. On the right, show a pink circular badge with the allergen count if they have any allergens.

If a child does not have photo consent, show a red banner at the bottom of their card reading "📵 No Photo Consent" with white text and a red background.

Tapping a card navigates to ChildProfileView passing the child object.

---

### Child Profile Screen

Show a back button in the navigation bar. The background is yellow.

At the top, show a large circle (80 points) with a purple background and the child's initials in white 28pt bold, centred. Below the circle, show the child's full name in the screen header font and their room name in caption gray below that.

If the child does not have photo consent, show a red warning card immediately below the name section. The card reads "⚠️ No Photography Consent — This child must not be photographed" with white text on a red background and a camera slash SF Symbol.

Show a section labelled "Allergens" with a horizontal flow of pink pill badges for each allergen. Use the allergen emoji icons from AllergenBadgeView. If no allergens, show a green "✓ No known allergens" caption.

Show a white card labelled "Today's Diary". Inside the card, show the count of diary entries logged today and a small ring chart (using Swift Charts SectorMark) showing the breakdown of entries by type using the entry type colours.

Show two purple buttons at the bottom: "📖 View Diary" and "➕ Add Log". Both navigate to DiaryTimelineView for this child. The Add Log button also sets a flag to immediately show the log card expanded when the timeline screen appears.

---

### Diary Timeline Screen

Show the navigation title as the child's preferred name followed by "'s Diary'" — for example "Emma's Diary". Show today's date as a subtitle formatted as the full weekday, day, and month — for example "Wednesday, 18 April".

The background is yellow. Query diary entries from SwiftData filtered by the child's id and today's date, sorted by timestamp ascending.

If the log card flag is set to true (from tapping Add Log on the profile), show the DiaryLogCard expanded at the top of the list immediately on appear.

Show each diary entry as a white card using CardStyle. Each card has a 4-point coloured left border matching the entry type colour. Inside the card, show the entry type's SF Symbol icon in the entry colour on the left, the summary text in card title font in the centre, and the timestamp formatted as a short time (e.g. 08:45) on the right.

Do not add any delete or swipe actions to the list. Entries are append-only. This is deliberate and must not be changed.

Show a purple floating button labelled "➕ Add Log" pinned above the safe area at the bottom of the screen. Tapping it expands the DiaryLogCard at the top of the scroll view using a spring animation.

---

### Diary Log Card

This is an inline expandable white card — it appears within DiaryTimelineView, not as a sheet or separate screen. It uses CardStyle with 16 points of internal padding.

At the top of the card, show a header row with the label "📝 Log Entry" in card title font and an X dismiss button on the right that collapses the card.

Below the header, show a horizontal scrolling row of type selector chips for the five main types: Activity, Meal, Nap, Nappy, and Mood. The active chip has a purple background with white text. Inactive chips have a white background with a purple border and purple text. Tapping a chip changes the selected type using a spring animation.

Below the chips, show different fields depending on the selected type. Use a switch statement to control which fields are shown. Animate between field sets using opacity and scale transitions.

For the Meal type: if the child has any allergens, show a pink allergen alert banner at the top of the field area reading "⚠️ Allergen Alert:" followed by the allergen names. The banner includes a toggle labelled "I have checked allergens for this meal" — this must be checked before the Save Log button becomes active for meal entries. Below the allergen banner, show a picker for meal type (Breakfast, Morning Snack, Lunch, Afternoon Snack, Dinner), a text field for foods offered, a row of six selectable consumption chips (All, Most, Half, Little, None, Refused) where only one can be active at a time shown in purple, a stepper for fluid volume in 50ml steps between 0 and 500ml showing the current value as a label, and a segmented control for fluid type (Water, Milk, Juice).

For the Activity type: show a text field for activity name, a picker for EYFS area (Communication and Language, Physical Development, Personal Social and Emotional, Literacy, Mathematics, Understanding the World, Expressive Arts and Design), and a stepper for duration in 5-minute steps between 5 and 120 minutes showing "Duration: X mins".

For the Nap type: show a date picker for start time in hours and minutes only, a date picker for end time in hours and minutes only, and a segmented control for sleep position with options Back and Side.

For the Nappy type: show four selectable chip buttons (Wet, Dirty, Both, None) for the nappy type, and a toggle labelled "Any concerns noted?" If the toggle is on, show a text field for describing the concern.

For the Mood type: show three large tappable cards arranged horizontally, each 70 by 70 points with white background and card corner radius. The first shows the 😊 emoji and the label "Happy". The second shows 😕 and "Unsettled". The third shows 🤒 and "Poorly". When one is selected, highlight it with a coloured border matching its meaning (green for happy, orange for unsettled, red for poorly).

At the bottom of all field sets, show a multiline text field labelled "Additional notes..." for free text.

Show a purple Save Log button using PurpleButton at the bottom of the card. When tapped, validate that required fields are filled. For meals, also check that the allergen toggle is acknowledged if allergens are present. If validation fails, show inline red error text below the button describing what is missing. If validation passes, create a DiaryEntry with all entered values, set the timestamp to the current time automatically, insert it into the SwiftData context, save, and collapse the card.

---

### Incident List Screen

The background is yellow. Show the heading "Incidents" and a subtitle showing the room name.

Show a purple full-width "➕ New Incident" button at the top that navigates to IncidentFormView.

Query incident reports from SwiftData for the current keyworker, sorted by timestamp descending.

Show each incident as a white card using CardStyle. The card shows the child's name in card title font, the incident category below it in body font, and the timestamp formatted as a relative time (e.g. "Today at 14:32") in caption gray. On the right, show a status pill: "Draft" with a pink background or "Submitted" with a purple background and white text. If sosActivated is true on the incident, show a small red badge reading "🆘 SOS Used" in the bottom right of the card.

If there are no incidents, show a centred empty state with a shield SF Symbol at 60 points in gray, the message "No incidents recorded" in gray body font, and the caption "Tap + New Incident to begin".

---

### Incident Form Screen

This is a single scrollable screen. There is no navigation to sub-screens. Everything is inline.

Show "New Incident" as the navigation title. Show a back button.

At the top of the scroll content, show a progress indicator: a horizontal row of three numbered dots labelled "Details", "Body Map", and "Review". A dot fills with purple when its section has been completed. This updates reactively as the user fills in the form.

**Section 1 — Details:**

Show a "Incident Details" section header in purple small caps style.

Show a picker labelled "Child" that lists the names of all children assigned to the current keyworker. The user selects which child this incident involves.

Show a read-only timestamp field displaying the current time. The field looks visually similar to a text field but is not editable. Below it, show a caption reading "🔒 Auto-recorded — cannot be edited". This is a GDPR and EYFS compliance requirement.

Show a text field for location.

Show a horizontal scrolling row of category chip buttons for all six incident categories. Active chip is purple with white text. Inactive chips are white with purple border. Only one category can be selected at a time.

If the Safeguarding Concern category is selected, animate in a pink warning card below the chips using an opacity and scale transition. The card reads "⚠️ Safeguarding Concern — Contact your Designated Safeguarding Lead immediately. Use the SOS button if the child is in immediate danger." The card has a pink background and black text.

Show a multiline text editor for incident description with a minimum height of 80 points and a placeholder "Describe what happened...".

Show a multiline text editor for immediate action taken with a minimum height of 60 points and a placeholder "What action was taken immediately?".

Show a text field for witness names with the placeholder "Names of witnesses, separated by commas".

**Section 2 — Body Map:**

Show a "Body Map" section header and a caption "Tap the body diagram to mark injury locations".

Show a segmented control to toggle between Front and Back views.

Show the BodyMapView inline below the toggle. This is not a button that reveals the map — the map is always visible within the form.

Below the body map, show the list of annotations that have been placed. Each annotation shows a small purple dot icon, the body side, and the note text.

**Section 3 — Review:**

Show a "Review" section header.

Show a read-only summary of the key details entered: child name, category, location, and a truncated version of the description.

Show a checkbox toggle labelled "I confirm this report is accurate and complete". This must be checked before submission is allowed.

At the very bottom, show a purple Submit Report button pinned using safeAreaInset on the bottom edge. When tapped, validate that a child is selected, the description is not empty, and the confirmation checkbox is checked. If validation fails, show inline red error text above the button. If validation passes, set the incident status to "submitted", save the record to SwiftData, and navigate back to the incident list.

---

### Body Map View

Show a white card containing a simple human body silhouette drawn using SwiftUI Canvas or Path shapes. The silhouette should show a head (circle), torso (rounded rectangle), two arms (rectangles angled slightly outward), and two legs (rectangles). Fill all shapes with gray at 15% opacity and stroke them with gray at 40% opacity using a line width of 1.5.

Use a GeometryReader to get the frame size. Apply a clear tap gesture over the entire silhouette area. When the user taps, convert the tap location to normalised coordinates between 0.0 and 1.0 for both x and y. Show a brief inline prompt asking for a short note to describe the injury location. When the user confirms, add a BodyMapAnnotation to the annotations binding with the coordinates, the current side (front or back), and the note.

Render existing annotations as small purple filled circles (12 points diameter) positioned over the silhouette using relative offsets calculated from the normalised coordinates and the GeometryReader frame size.

---

### SOS Button

The SOS button is a persistent floating element sitting in the bottom right corner of the screen above the tab bar at all times after login. It must use z-order positioning to stay above all other content.

The button is a pink filled circle 56 points in diameter. It shows the 🆘 emoji at 24pt and the label "SOS" in 10pt black bold rounded font below it.

Behind the button, render a pulsing ring: a pink stroke circle that continuously scales from 1.0 to 1.5 and fades from 80% to 0% opacity on a repeating 1.2 second ease-out animation. This animation starts on appear and never stops.

The button has a pink drop shadow to give it elevation. Tapping the button triggers the SOS overlay.

---

### SOS Overlay Screen

This appears as a full screen cover over whatever screen is currently visible.

The background is a near-black semi-transparent overlay filling the entire screen including safe areas.

In the centre of the screen, show a white card with 24 points of padding and a corner radius of 24. Inside the card: a 🚨 emoji at 48pt, the heading "Emergency" in 26pt bold black, and a caption "Tap to call emergency services" in gray.

Show a divider, then three full-width call buttons stacked vertically with 12 points of spacing between them. Each button is 64 points tall with a corner radius of 14 and white bold text. The first button reads "🚑 Call Ambulance" with a red background (#FF3B30). The second reads "🚒 Call Fire Brigade" with an orange background (#FF9500). The third reads "🏥 Call Hospital (A&E)" with a blue background (#007AFF).

When any call button is tapped, briefly show a "📞 Calling [service name]..." banner at the top of the card for 1.5 seconds, then trigger a phone call using UIApplication openURL with the tel://999 scheme.

Below the call buttons, show a gray full-width Cancel button that dismisses the overlay.

---

## SHARED COMPONENTS

**AllergenBadgeView** is a small pink pill (corner radius 99) showing an emoji icon and the allergen name in 12pt medium black text. The emoji mapping is: Milk = 🥛, Eggs = 🥚, Nuts or Peanuts = 🥜, Fish = 🐟, Gluten or Wheat = 🌾, all others = ⚠️.

**ConsentBannerView** is a red banner with a camera slash SF Symbol and the text "No Photography Consent — Do not photograph this child" in white 12pt semibold. It spans the full width and has 12 points of padding and a corner radius of 12.

**BrandComponents** contains the CardStyle ViewModifier, PurpleButton ViewModifier, and the Color hex initialiser extension. All shared styling helpers live here.

---

## VIEWMODELS

**AuthViewModel** is marked @Observable. It holds email, password, error message, and a showError boolean. It has a signIn method that compares the entered credentials against the hardcoded valid values (keyworker@littlestars.co.uk and Stars2024!). On success it calls a completion handler. On failure it sets the error message and animates showError to true.

**ChildListViewModel** is marked @Observable. It holds a search query string and provides a filtered list of children. It does not hold the SwiftData query itself — that lives in the view using @Query.

**DiaryViewModel** is marked @Observable. It holds the currently selected entry type for the log card, all the transient form field values, a boolean for whether the log card is showing, and a validation error message. It has a saveEntry method that creates and inserts a DiaryEntry into the SwiftData context.

**IncidentViewModel** is marked @Observable. It holds all the transient field values for the incident form, the list of body map annotations, the current body map side, the set of completed section indices for the progress indicator, and validation state. It has a submitReport method that creates and inserts an IncidentReport into the SwiftData context.

---

## CRITICAL RULES

These rules must be enforced without exception.

The diary entry timestamp must be set automatically at the moment of creation and must never be exposed as an editable field in the UI anywhere in the app.

The incident report timestamp must be set automatically at the moment of creation. The form must display it as read-only text with a locked padlock caption.

Diary entries must have no delete functionality anywhere in the UI. No swipe actions, no edit mode, no context menus with delete options. This simulates an immutable audit trail for GDPR compliance.

The SOS button must be visible on every screen after login. It must float above all other UI including tab bars, navigation bars, and content. Use ZStack positioning to achieve this.

The allergen acknowledgement toggle in the meal log card must be checked before the Save Log button is enabled for meal entries when the child has allergens. If the toggle is not checked, tapping Save shows an inline error.

The Safeguarding Concern category in the incident form must always trigger the animated pink warning card. This is a safeguarding requirement.

The data minimisation rule must be enforced: every query for children and diary entries must include a predicate filtering by the current keyworker's UUID. Children belonging to other keyworkers must never appear in any list or search result.

Validation errors must always appear as inline text below the relevant button, not as alert dialogs or action sheets. Use red small text.

Navigation must use NavigationStack exclusively. NavigationView must not appear anywhere in the codebase.

The entire app is light mode only. Do not add dark mode support.

---

## TESTING REQUIREMENTS

Write unit tests covering: correct login succeeds, incorrect login sets error state, diary entry timestamp is set to current time automatically, all six meal consumption levels persist and decode correctly, nap duration is calculated correctly from start and end times, data minimisation query only returns children with the correct keyworker UUID, new incident report defaults to draft status, SOS activated flag defaults to false, and body map annotations encode and decode correctly.

Write UI tests covering: splash screen completes and login screen appears, correct credentials navigate to the dashboard, wrong credentials show an inline error banner without crashing, the SOS button is visible on the dashboard screen, tapping SOS opens the overlay with three call buttons, tapping Cancel on the SOS overlay dismisses it, tapping Add Log expands the diary log card inline, switching between diary entry type chips changes the visible fields, submitting a diary entry makes it appear in the timeline, the incident form timestamp field is visible but not editable, tapping the body map silhouette creates an annotation, and submitting a complete incident form changes its status pill to Submitted.

---

*NurseryConnect Claude Code Specification v2.0 — SE4020 Assignment 1 — Semester 1, 2026*
