#include <random>
#include "crow_all.h"

int main() {
  crow::SimpleApp app;
  std::unordered_map<std::string, std::string> game_id_to_ip;

  // Register a server for match making
  CROW_ROUTE(app, "/host")
      .methods("GET"_method)([&game_id_to_ip](const crow::request& req) {
        const char* host_ip = req.url_params.get("ip");
        if (!host_ip) {
          return std::string("Must provide host IP address");
        }

        const char* game_id = req.url_params.get("g");
        if (!game_id) {
          return std::string("Must provide a game id");
        }

        game_id_to_ip[game_id] = host_ip;

        return std::string("Match created with game id " +
                           std::string(game_id));
      });

  // Register a server for match making
  CROW_ROUTE(app, "/join")
      .methods("GET"_method)([&game_id_to_ip](const crow::request& req) {
        const char* game_id = req.url_params.get("g");
        if (!game_id) {
          return std::string("Must provide a game id");
        }

        const auto iter = game_id_to_ip.find(game_id);
        if (iter == game_id_to_ip.end()) {
          return std::string("Invalid game id");
        }
        return game_id_to_ip[game_id];
      });

  app.port(8080).run();
}
