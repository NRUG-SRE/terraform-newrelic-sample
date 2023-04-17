import React, { useState } from 'react';

function App() {
    const [apiResponse, setApiResponse] = useState(null);

    const fetchApiData = async () => {
        try {
            const response = await fetch('http://localhost:8000/bff/tracing-demo');
            const data = await response.json();
            setApiResponse(JSON.stringify(data, null, 2));
        } catch (error) {
            console.error('Error fetching API data:', error);
            setApiResponse('Error fetching API data.');
        }
    };

    return (
        <div className="App">
            <header className="App-header">
                <h1>New Relic Browser Monitoring Example</h1>
                <p>This is a simple page to demonstrate New Relic Browser Monitoring with a React application.</p>
                <button onClick={fetchApiData}>Fetch API Data</button>
                {apiResponse && (
                    <pre>
            <code>{apiResponse}</code>
          </pre>
                )}
            </header>
        </div>
    );
}

export default App;
