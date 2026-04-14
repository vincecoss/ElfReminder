import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateDisplay()
        buildMenu()
        scheduleTimer()
    }

    // MARK: - Display

    private func updateDisplay() {
        let days = daysUntilChristmas()
        let title: String
        if days == 0 {
            title = "🎄 Today!"
        } else if days == 1 {
            title = "🎄 1 day"
        } else {
            title = "🎄 \(days) days"
        }

        if let button = statusItem.button {
            button.title = title
        }
    }

    // MARK: - Menu

    private func buildMenu() {
        let menu = NSMenu()

        let days = daysUntilChristmas()
        let header: String
        if days == 0 {
            header = "Merry Christmas!"
        } else {
            header = "\(days) day\(days == 1 ? "" : "s") until Christmas"
        }
        let infoItem = NSMenuItem(title: header, action: nil, keyEquivalent: "")
        infoItem.isEnabled = false
        menu.addItem(infoItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - Timer

    private func scheduleTimer() {
        // Refresh at midnight and every hour as a safety net
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.updateDisplay()
            self?.buildMenu()
        }
    }

    // MARK: - Calculation

    private func daysUntilChristmas() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)

        var christmasComponents = DateComponents()
        christmasComponents.month = 12
        christmasComponents.day = 25
        christmasComponents.year = year

        guard var christmas = calendar.date(from: christmasComponents) else { return 0 }

        // If Christmas has passed this year, target next year
        if calendar.compare(now, to: christmas, toGranularity: .day) == .orderedDescending {
            christmasComponents.year = year + 1
            christmas = calendar.date(from: christmasComponents) ?? christmas
        }

        let startOfToday = calendar.startOfDay(for: now)
        let startOfChristmas = calendar.startOfDay(for: christmas)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfChristmas)
        return max(components.day ?? 0, 0)
    }

    // MARK: - Actions

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
