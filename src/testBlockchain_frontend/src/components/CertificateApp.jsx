
import React, { useState } from 'react';
import './CertificateApp.css'; // Import your CSS file
import TextDisplay from './TextDisplay'; // Make sure to provide the correct path
import { testBlockchain_backend } from '../../../declarations/testBlockchain_backend';

function CertificateApp() {
  const [name, setName] = useState('');
  const [inputData, setInputData] = useState('');
  const [registeredMsg, setRegisteredMsg] = useState('');
  const [id, setId] = useState('');

  const handleNameChange = async (e) => {
    setName(e.target.value);
  };

  const handleInputDataChange = (e) => {
    setInputData(e.target.value);
  };

  const handleRegister = async () => {
    const regMsg = await testBlockchain_backend.registerUser(name);
    setRegisteredMsg(regMsg);
  };

  const getIdd = async () => {
    const id = await testBlockchain_backend.getId();
    setId(id);
  }

  return (
    <div className="container">
      <h1>Register Yourself for a Certification</h1>
      <div>
        <label>
          Enter Your Name:
          <input type="text" value={name} onChange={handleNameChange} />
        </label>
        <button onClick={handleRegister}>Register</button>
      </div>
      {registeredMsg && <div className="result">{registeredMsg}</div>}
      <div className="id-section">
        <h1>Get Your ID</h1>
        {id ? "your id is "+ id : (
          <button className="id-button" onClick={getIdd}>Get ID</button>
        )}
      </div>
      <TextDisplay className="text-display" />
    </div>
  );
}

export default CertificateApp;