import React, { useState } from 'react';
import { Pie } from 'react-chartjs-2';
import './App.css';

const App = () => {
  const [totalBudget, setTotalBudget] = useState(0);
  const [departments, setDepartments] = useState([
    { name: 'Marketing', allocation: 0 },
    { name: 'R&D', allocation: 0 },
    { name: 'Operations', allocation: 0 },
    { name: 'HR', allocation: 0 },
  ]);
  const [errors, setErrors] = useState({});

  const handleBudgetChange = (e) => {
    const newTotalBudget = Number(e.target.value);
    if (newTotalBudget < 0) {
      setErrors({ ...errors, totalBudget: 'Total budget cannot be negative' });
    } else {
      setErrors({ ...errors, totalBudget: '' });
      setTotalBudget(newTotalBudget);
    }
  };

  const handleAllocationChange = (index, value) => {
    const newValue = Number(value);
    const newDepartments = [...departments];
    newDepartments[index].allocation = newValue;

    const totalAllocated = newDepartments.reduce((sum, dept) => sum + dept.allocation, 0);
    if (newValue < 0) {
      setErrors({ ...errors, [`dept${index}`]: `${newDepartments[index].name} allocation cannot be negative` });
    } else if (totalAllocated > totalBudget) {
      setErrors({ ...errors, [`dept${index}`]: 'Total allocated exceeds total budget' });
    } else {
      setErrors({ ...errors, [`dept${index}`]: '' });
      setDepartments(newDepartments);
    }
  };

  const remainingBudget = totalBudget - departments.reduce((sum, dept) => sum + dept.allocation, 0);

  const chartData = {
    labels: departments.map(dept => dept.name),
    datasets: [
      {
        data: departments.map(dept => dept.allocation),
        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
      },
    ],
  };

  return (
    <div className="App">
      <h1>Company Budget Allocation</h1>
      <div>
        <label>
          Total Budget: $
          <input
            type="number"
            value={totalBudget}
            onChange={handleBudgetChange}
            min="0"
          />
        </label>
        {errors.totalBudget && <div className="error">{errors.totalBudget}</div>}
      </div>
      <h2>Allocate Budget</h2>
      {departments.map((dept, index) => (
        <div key={index}>
          <label>
            {dept.name}: $
            <input
              type="number"
              value={dept.allocation}
              onChange={(e) => handleAllocationChange(index, e.target.value)}
              min="0"
              max={totalBudget}
            />
          </label>
          {errors[`dept${index}`] && <div className="error">{errors[`dept${index}`]}</div>}
        </div>
      ))}
      <h2>Summary</h2>
      <div>Total Allocated: ${totalBudget - remainingBudget}</div>
      <div>Remaining Budget: ${remainingBudget}</div>
      <h2>Budget Allocation Chart</h2>
      <Pie data={chartData} />
    </div>
  );
};

export default App;
