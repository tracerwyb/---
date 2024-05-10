#ifndef CLIENT_H
#define CLIENT_H

namespace FrameworkDesign {
	class Client {

	private:
		static Client* m_instance;
		Network m_network;

	public:
		static Client* getInstance();

		void send(const char* buf, size_t size);

		bool receive(char* buf);

		void start();

		void reconnect();

		std::string receiveFile();

		void closeSocket();
	};
}

#endif
