//
//  SwipeAction.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI

/// Represents a custom swipe action view for SwiftUI.
struct SwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    /// Environment properties
    @Environment(\.colorScheme) private var scheme
    
    /// State properties
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    
    /// Unique identifier for the content view
    private let viewID = "CONTENTVIEW"
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    content
                    actionButtons(resetPosition: { scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .leading : .trailing) })
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .rotationEffect(.degrees(direction == .leading ? 180 : 0))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    /// The primary content view with swipe detection.
    private var contentView: some View {
        content
            .rotationEffect(.degrees(direction == .leading ? -180 : 0))
            .containerRelativeFrame(.horizontal)
            .background(scheme == .dark ? .black : .white)
            .background(actionColor)
            .id(viewID)
            .overlay(offsetTracker)
    }
    
    /// Overlay to track the scroll offset.
    private var offsetTracker: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: OffsetKey.self, value: geo.frame(in: .scrollView(axis: .horizontal)).minX)
                .onPreferenceChange(OffsetKey.self) { scrollOffset = $0 }
        }
    }
    
    /// Background color based on the first action's tint.
    private var actionColor: some View {
        if let firstAction = filteredActions.first {
            Rectangle()
                .fill(firstAction.tint)
                .opacity(scrollOffset == .zero ? 0 : 1) as! _ShapeView<Rectangle, Color>
        } else {
            Rectangle().fill(.clear)
        }
    }
    
    /// Background color for the entire swipe area.
    private var backgroundColor: some View {
        if let lastAction = filteredActions.last {
            Rectangle()
                .fill(lastAction.tint)
                .opacity(scrollOffset == .zero ? 0 : 1) as! _ShapeView<Rectangle, Color>
        } else {
            Rectangle().fill(.clear)
        }
    }
    
    /// Renders the action buttons based on swipe direction.
    @ViewBuilder
    private func actionButtons(resetPosition: @escaping () -> Void) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { action in
                        SwipeActionButton(action: action, resetPosition: resetPosition)
                    }
                }
            }
    }
    
    /// Filters out disabled actions.
    private var filteredActions: [Action] {
        actions.filter { $0.isEnabled }
    }
}

/// Helper struct for rendering each action button.
private struct SwipeActionButton: View {
    let action: Action
    let resetPosition: () -> Void
    
    var body: some View {
        Button(action: {
            Task {
                isEnabled = false
                resetPosition()
                try? await Task.sleep(for: .seconds(0.3))
                action.action()
                try? await Task.sleep(for: .seconds(0.05))
                isEnabled = true
            }
        }) {
            Image(systemName: action.icon)
                .font(action.iconFont)
                .foregroundStyle(action.iconTint)
                .frame(width: 100)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(action.tint)
    }
    
    @State private var isEnabled: Bool = true
}

/// Custom transition for the swipe action.
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader { geo in
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -geo.size.height)
                }
            }
    }
}

/// Key for tracking offset in scroll view.
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Enum to define swipe direction.
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}

/// Model for defining an action in the swipe view.
struct Action: Identifiable {
    let id = UUID()
    let tint: Color
    let icon: String
    let iconFont: Font
    let iconTint: Color
    let isEnabled: Bool
    let action: () -> Void
    
    init(tint: Color, icon: String, iconFont: Font = .title, iconTint: Color = .white, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.tint = tint
        self.icon = icon
        self.iconFont = iconFont
        self.iconTint = iconTint
        self.isEnabled = isEnabled
        self.action = action
    }
}

/// Builder for creating an array of `Action`s.
@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        components
    }
}
