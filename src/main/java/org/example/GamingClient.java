package org.example;

import javax.swing.*;
import java.awt.*;
import java.sql.*;
import java.util.Timer;
import java.util.TimerTask;

public class GamingClient extends JFrame {
    // Composants d'interface
    private final JPanel mainPanel;
    private final CardLayout cardLayout;
    private JPanel loginPanel;
    private JPanel dashboardPanel;
    private JPanel codePanel;

    // Composants du login
    private JTextField usernameField;
    private JPasswordField passwordField;

    // Composants du panneau de code
    private JTextField codeField;

    // Composants du dashboard
    private JLabel welcomeLabel;
    private JLabel timeLeftLabel;
    private JLabel packageInfoLabel;

    // Variables pour la session
    private String userId;
    private String firstName;
    private String lastName;
    private int packageId;
    private int timeLeftSeconds;
    private Timer sessionTimer;

    // Constantes de base de données
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ap2";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    public GamingClient() {
        // Configuration de la fenêtre principale
        setTitle("Cyber Game Arras");
        setSize(500, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Création du layout principal
        mainPanel = new JPanel();
        cardLayout = new CardLayout();
        mainPanel.setLayout(cardLayout);

        // Initialiser les panneaux
        initLoginPanel();
        initCodePanel();
        initDashboardPanel();

        // Ajouter les panneaux au layout principal
        mainPanel.add(loginPanel, "login");
        mainPanel.add(codePanel, "code");
        mainPanel.add(dashboardPanel, "dashboard");

        // Afficher le panneau de login par défaut
        cardLayout.show(mainPanel, "login");

        // Ajouter le panneau principal à la fenêtre
        add(mainPanel);
    }

    private void initLoginPanel() {
        loginPanel = new JPanel();
        loginPanel.setLayout(new GridBagLayout());
        loginPanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(5, 5, 5, 5);

        JLabel titleLabel = new JLabel("Connexion", JLabel.CENTER);
        titleLabel.setFont(new Font("Arial", Font.BOLD, 24));
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(10, 5, 20, 5);
        loginPanel.add(titleLabel, gbc);

        JLabel usernameLabel = new JLabel("Username:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.gridwidth = 1;
        gbc.insets = new Insets(5, 5, 5, 5);
        loginPanel.add(usernameLabel, gbc);

        usernameField = new JTextField(15);
        gbc.gridx = 1;
        gbc.gridy = 1;
        loginPanel.add(usernameField, gbc);

        JLabel passwordLabel = new JLabel("Password:");
        gbc.gridx = 0;
        gbc.gridy = 2;
        loginPanel.add(passwordLabel, gbc);

        passwordField = new JPasswordField(15);
        gbc.gridx = 1;
        gbc.gridy = 2;
        loginPanel.add(passwordField, gbc);

        JButton loginButton = new JButton("Login");
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(15, 5, 5, 5);
        loginPanel.add(loginButton, gbc);

        // Action pour le bouton de login
        loginButton.addActionListener(e -> {
            String username = usernameField.getText();
            String password = new String(passwordField.getPassword());

            if (authenticateUser(username, password)) {
                cardLayout.show(mainPanel, "code");
                usernameField.setText("");
                passwordField.setText("");
            } else {
                JOptionPane.showMessageDialog(this,
                        "Invalid username or password",
                        "Authentication Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        });
    }

    private void initCodePanel() {
        codePanel = new JPanel();
        codePanel.setLayout(new GridBagLayout());
        codePanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(5, 5, 5, 5);

        JLabel titleLabel = new JLabel("Entrer votre code", JLabel.CENTER);
        titleLabel.setFont(new Font("Arial", Font.BOLD, 24));
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(10, 5, 20, 5);
        codePanel.add(titleLabel, gbc);

        JLabel codeLabel = new JLabel("Code:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.gridwidth = 1;
        gbc.insets = new Insets(5, 5, 5, 5);
        codePanel.add(codeLabel, gbc);

        codeField = new JTextField(10);
        gbc.gridx = 1;
        gbc.gridy = 1;
        codePanel.add(codeField, gbc);

        JButton validateCodeButton = new JButton("Démarrer");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(15, 5, 5, 5);
        codePanel.add(validateCodeButton, gbc);

        JButton backToLoginButton = new JButton("Retour");
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        codePanel.add(backToLoginButton, gbc);

        // Action pour le bouton de validation de code
        validateCodeButton.addActionListener(e -> {
            String code = codeField.getText();
            if (validatePackageCode(code)) {
                loadUserPackageInfo();
                startSession();
                cardLayout.show(mainPanel, "dashboard");
                codeField.setText("");
            } else {
                JOptionPane.showMessageDialog(this,
                        "Invalid package code",
                        "Validation Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        });

        // Action pour le bouton de retour
        backToLoginButton.addActionListener(e -> {
            cardLayout.show(mainPanel, "login");
            codeField.setText("");
        });
    }

    private void initDashboardPanel() {
        dashboardPanel = new JPanel();
        dashboardPanel.setLayout(new GridBagLayout());
        dashboardPanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(5, 5, 5, 5);

        JLabel titleLabel = new JLabel("Cyber Game Arras", JLabel.CENTER);
        titleLabel.setFont(new Font("Arial", Font.BOLD, 24));
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(10, 5, 20, 5);
        dashboardPanel.add(titleLabel, gbc);

        welcomeLabel = new JLabel("Bienvenue");
        welcomeLabel.setFont(new Font("Arial", Font.BOLD, 18));
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.gridwidth = 2;
        dashboardPanel.add(welcomeLabel, gbc);

        packageInfoLabel = new JLabel("Package: ");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        dashboardPanel.add(packageInfoLabel, gbc);

        timeLeftLabel = new JLabel("Temps restant: ");
        timeLeftLabel.setFont(new Font("Arial", Font.BOLD, 16));
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(20, 5, 20, 5);
        dashboardPanel.add(timeLeftLabel, gbc);

        JButton logoutButton = new JButton("Terminer");
        gbc.gridx = 0;
        gbc.gridy = 4;
        gbc.gridwidth = 2;
        dashboardPanel.add(logoutButton, gbc);

        // Action pour le bouton de déconnexion
        logoutButton.addActionListener(e -> {
            endSession();
            cardLayout.show(mainPanel, "login");
        });
    }

    private boolean authenticateUser(String username, String password) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT id, first_name, last_name, password FROM users WHERE username = ? AND active = 1";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                // Dans un environnement réel, vous devriez utiliser BCrypt pour vérifier le mot de passe
                // Pour simplifier, nous supposons un mot de passe en texte brut dans cet exemple
                if (BCrypt.checkpw(password, storedPassword)) {
                    userId = rs.getString("id");
                    firstName = rs.getString("first_name");
                    lastName = rs.getString("last_name");
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this,
                    "Database error: " + e.getMessage(),
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
            return false;
        }
    }

    private boolean validatePackageCode(String code) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("Checking package code: " + code);

            int codeInt;
            try {
                codeInt = Integer.parseInt(code);
            } catch (NumberFormatException e) {
                System.out.println("Error: Code is not a valid number.");
                JOptionPane.showMessageDialog(this, "Invalid code format!", "Error", JOptionPane.ERROR_MESSAGE);
                return false;
            }

            String query = "SELECT id FROM packages WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, codeInt);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                packageId = rs.getInt("id");
                System.out.println("Package found: " + packageId);
                return true;
            } else {
                System.out.println("No package found with code: " + code);
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    private void loadUserPackageInfo() {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT p.nom, p.description, p.prix FROM packages p WHERE p.id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, packageId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String packageName = rs.getString("nom");
                String description = rs.getString("description");
                String price = rs.getString("prix");

                packageInfoLabel.setText("Package: " + packageName + " - " + description + " - " + price);

                // Extraire le temps du forfait (ex: "1h" -> 3600 secondes)
                if (description.contains("h")) {
                    String hours = description.replaceAll("[^0-9]", "");
                    timeLeftSeconds = Integer.parseInt(hours) * 3600;
                } else {
                    // Par défaut 1 heure si format non reconnu
                    timeLeftSeconds = 3600;
                }

                updateTimeLabel();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void startSession() {
        welcomeLabel.setText("Bienvenue, " + firstName + " " + lastName + "!");

        // Démarrer le timer pour décompter le temps
        sessionTimer = new Timer();
        sessionTimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                if (timeLeftSeconds > 0) {
                    timeLeftSeconds--;
                    SwingUtilities.invokeLater(() -> updateTimeLabel());
                } else {
                    // Fin du temps
                    SwingUtilities.invokeLater(() -> {
                        JOptionPane.showMessageDialog(GamingClient.this,
                                "Your time has expired!",
                                "Session Ended",
                                JOptionPane.INFORMATION_MESSAGE);
                        endSession();
                        cardLayout.show(mainPanel, "login");
                    });
                    cancel();
                }
            }
        }, 0, 1000);
    }

    private void updateTimeLabel() {
        int hours = timeLeftSeconds / 3600;
        int minutes = (timeLeftSeconds % 3600) / 60;
        int seconds = timeLeftSeconds % 60;

        timeLeftLabel.setText(String.format("Temps restant: %02d:%02d:%02d", hours, minutes, seconds));
    }

    private void endSession() {
        if (sessionTimer != null) {
            sessionTimer.cancel();
            sessionTimer = null;
        }

        // Réinitialiser les variables de session
        userId = null;
        firstName = null;
        lastName = null;
        packageId = 0;
        timeLeftSeconds = 0;
    }

    public static void main(String[] args) {
        // Charger le driver JDBC
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null,
                    "MySQL JDBC Driver not found!",
                    "Database Error",
                    JOptionPane.ERROR_MESSAGE);
            System.exit(1);
        }

        // Lancer l'application
        SwingUtilities.invokeLater(() -> {
            GamingClient client = new GamingClient();
            client.setVisible(true);
        });
    }

    // Classe utilitaire pour vérifier les mots de passe hachés avec BCrypt
    // Implémentation simplifiée pour l'exemple
    static class BCrypt {
        public static boolean checkpw(String plaintext, String hashed) {
            // Dans une application réelle, utilisez la bibliothèque jBCrypt
            // Pour cet exemple, nous simulons simplement un check BCrypt
            // en vérifiant si le mot de passe haché commence par $2y$
            return hashed.startsWith("$2y$") && !plaintext.isEmpty();
        }
    }
}