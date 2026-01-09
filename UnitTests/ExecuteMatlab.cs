using System;
using System.Collections.Generic;
using System.IO;
using Xunit;
using GRASP_Builder.Matlab;
using GRASP_Builder.Matlab.MatlabScriptsImplementations;
using GRASP_Builder;

namespace UnitTests
{
    public class ExecuteMatlab
    {
        
        [Fact]
        public void MatlabScriptFactory_CreatesExpectedTypes()
        {
            var dict = new Dictionary<string, object> { ["a"] = "1" };

            var send = MatlabScriptFactory.Create(ScriptType.SendFiles, dict);
            Assert.IsType<SendFiles>(send);

            var save = MatlabScriptFactory.Create(ScriptType.SaveFigures, new Dictionary<string, object>());
            Assert.IsType<SaveFigures>(save);

            var plot = MatlabScriptFactory.Create(ScriptType.PlotFigure, new Dictionary<string, object>());
            Assert.Equal("PlotFigure.m", plot.Name);
        }

        [Fact]
        public void SaveFigures()
        {

        }

        [Fact]
        public void SendFiles()
        {

        }

        [Fact]
        public void MatlabController()
        {
            
        }
    }
}
