import React from 'react'

export function Checkbox({ children, className = "", ...props }) {
  return (
    <div className="form-check">
      <input 
        type="checkbox" 
        className={`form-check-input ${className}`}
        {...props} 
      />
      <label className="form-check-label">
        {children}
      </label>
    </div>
  )
}

export default Checkbox