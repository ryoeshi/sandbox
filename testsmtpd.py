import asyncore
import smtpd

__all__ = ['TestSmtpd', 'TestSMTPChannel']
__version__ = 'Test smtpd 1.0';
 
class TestSmtpd(smtpd.PureProxy):
    def handle_accept(self):
        conn, addr = self.accept()
        print >> smtpd.DEBUGSTREAM, 'Incoming connection from %s' % repr(addr)
        channel = TestSMTPChannel(self, conn, addr)

class TestSMTPChannel(smtpd.SMTPChannel):

    def smtp_TEST(self, arg):
        self.push('Test print HOGE arg=%s' % arg)
        
if __name__ == '__main__':

    test_smtpd = TestSmtpd(('0.0.0.0', 8025), ('localhost', 25))
    asyncore.loop()

