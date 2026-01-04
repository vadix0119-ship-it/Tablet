CREATE TABLE IF NOT EXISTS tablet_devices (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL UNIQUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    locked TINYINT(1) NOT NULL DEFAULT 0,
    failed_attempts INT NOT NULL DEFAULT 0,
    lock_until INT NULL,
    pin_hash VARCHAR(255) NULL,
    setup_done TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tablet_profiles (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL,
    profile_id INT NOT NULL DEFAULT 1,
    display_name VARCHAR(32) NOT NULL DEFAULT 'Tablet',
    language VARCHAR(8) NOT NULL DEFAULT 'de',
    theme VARCHAR(16) NOT NULL DEFAULT 'auto',
    accent VARCHAR(16) NOT NULL DEFAULT '#4e8ef7',
    wallpaper VARCHAR(128) NOT NULL DEFAULT 'aurora-orange',
    settings_json LONGTEXT NULL,
    INDEX idx_device (device_id),
    FOREIGN KEY (device_id) REFERENCES tablet_devices (device_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tablet_notes (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL,
    title VARCHAR(64) NOT NULL DEFAULT '',
    content LONGTEXT NULL,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_device (device_id),
    FOREIGN KEY (device_id) REFERENCES tablet_devices (device_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tablet_notifications (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL,
    title VARCHAR(64) NOT NULL,
    message VARCHAR(255) NOT NULL,
    icon VARCHAR(32) NOT NULL DEFAULT 'info',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    `read` TINYINT(1) NOT NULL DEFAULT 0,
    INDEX idx_device (device_id),
    FOREIGN KEY (device_id) REFERENCES tablet_devices (device_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tablet_installed_apps (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(64) NOT NULL,
    app_id VARCHAR(64) NOT NULL,
    installed TINYINT(1) NOT NULL DEFAULT 1,
    meta_json LONGTEXT NULL,
    INDEX idx_device (device_id),
    FOREIGN KEY (device_id) REFERENCES tablet_devices (device_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
