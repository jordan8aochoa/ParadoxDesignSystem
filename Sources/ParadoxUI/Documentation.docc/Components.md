# Components

A tour of every Paradox component with usage snippets.

## Overview

Paradox ships 17 components across five families. Each is theme-driven, accessibility-aware, and tested with snapshot baselines. Reach for them before building bespoke chrome.

## Buttons

Six variants exposed as `ButtonStyle` extensions:

```swift
Button("Save")    { }.buttonStyle(.paradoxPrimary)
Button("Cancel")  { }.buttonStyle(.paradoxSecondary)
Button("Skip")    { }.buttonStyle(.paradoxTertiary)
Button("Outline") { }.buttonStyle(.paradoxGhost)
Button("Delete")  { }.buttonStyle(.paradoxDestructive)
Button("Forgot?") { }.buttonStyle(.paradoxLink)
```

Sizing comes from `.controlSize(.small/.regular/.large)`. Add a loading state with `.paradoxLoading(true)`, override haptics with `.paradoxHaptic(.medium)`.

## Cards & list items

```swift
ParadoxCard {
    Text("Premium feature")
        .paradoxText(theme.typography.titleSmall)
}

List {
    ParadoxListItem(
        title: "Notifications",
        subtitle: "12 unread",
        leading: { ParadoxAccessory.icon("bell.fill") },
        onTap: { open() }
    )
}
```

## Inputs

```swift
TextField("Email", text: $email)
    .paradoxTextFieldStyle()
    .paradoxFieldMessage(email.isEmpty ? .error("Required") : nil)

ParadoxToggle("Notifications", isOn: $enabled)
```

## Badges & avatars

```swift
ParadoxBadge(count: 12)                          // standalone
Image(systemName: "bell").paradoxBadge(count: 3) // overlay

ParadoxAvatar(url: user.imageURL, fallback: "JC")
    .controlSize(.large)
```

## Navigation & chrome

```swift
VStack(spacing: 0) {
    ParadoxNavigationBar(
        title: "Inbox",
        subtitle: "12 unread",
        leading: { Image(systemName: "chevron.left") },
        trailing: { Image(systemName: "square.and.pencil") }
    )

    ParadoxSegmentedControl(selection: $mode, segments: [
        .init(tag: .day, label: "Day"),
        .init(tag: .week, label: "Week")
    ])

    ScrollView { ... }

    ParadoxTabBar(selection: $tab, items: [
        .init(tag: .home,   systemImage: "house.fill",      title: "Home"),
        .init(tag: .search, systemImage: "magnifyingglass", title: "Search", badge: 12),
        .init(tag: .me,     systemImage: "person.fill",     title: "Me")
    ])
}
```

## Overlays

```swift
// Modal — drops into .sheet
.sheet(isPresented: $showDelete) {
    ParadoxModal(
        title: "Delete account?",
        subtitle: "This can't be undone.",
        primaryAction: .init(title: "Delete", role: .destructive) { confirm() },
        secondaryAction: .init(title: "Cancel") { showDelete = false }
    ) {
        Text("All your data will be permanently removed.")
    }
}

// Bottom sheet
content.paradoxBottomSheet(isPresented: $showFilters, detent: .medium) {
    FilterList()
}

// Toast
@State var toast: ParadoxToast.Model?
content.paradoxToast(item: $toast)
// then: toast = .init(title: "Saved", variant: .success)

// Context menu
Image("photo").paradoxContextMenu([
    .action("Share",  systemImage: "square.and.arrow.up") { share() },
    .action("Copy",   systemImage: "doc.on.doc")          { copy() },
    .divider,
    .action("Delete", systemImage: "trash", role: .destructive) { delete() }
])

// Floating action button
content.overlay(alignment: .bottomTrailing) {
    ParadoxFAB.circular(systemImage: "plus", accessibilityLabel: "Create") {
        create()
    }
    .padding(16)
}
```

## Topics

### Buttons

- ``ParadoxButtonStyle``
- ``ParadoxHaptic``

### Cards & lists

- ``ParadoxCard``
- ``ParadoxListItem``
- ``ParadoxAccessory``

### Inputs

- ``ParadoxTextFieldStyleModifier``
- ``ParadoxFieldMessage``
- ``ParadoxToggle``

### Badges & avatars

- ``ParadoxBadge``
- ``ParadoxAvatar``

### Navigation & chrome

- ``ParadoxNavigationBar``
- ``ParadoxTabBar``
- ``ParadoxSegmentedControl``
- ``ParadoxSearchBar``

### Overlays

- ``ParadoxModal``
- ``ParadoxBottomSheetContainer``
- ``ParadoxBottomSheetDetent``
- ``ParadoxToast``
- ``ParadoxContextAction``
- ``ParadoxFAB``
