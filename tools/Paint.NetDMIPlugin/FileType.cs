using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PaintDotNet;
using PaintDotNet.Data;
using System.IO;
using System.Drawing;
using System.Windows.Forms;

namespace PDN.DMIPlugin
{
	public sealed class DMIFileType : FileType, IFileTypeFactory
	{
		public DMIFileType()
			: base("DMI", FileTypeFlags.SupportsSaving | FileTypeFlags.SavesWithProgress | FileTypeFlags.SupportsLoading, new[] { ".dmi" }) { }

		protected override Document OnLoad(Stream input)
		{
			try
			{
				Bitmap b = new Bitmap(input, true);

				return Document.FromImage(b);
			}
			catch
			{
				MessageBox.Show("There was an error loading the image!", "DMI Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

				Bitmap b = new Bitmap(26, 10);
				return Document.FromImage(Paint.NetDMIPlugin.Properties.Resources.robust);
			}
		}

		protected override void OnSave(Document input, Stream output, SaveConfigToken token, Surface surface, ProgressEventHandler callback)
		{
			// Do save operation...

			RenderArgs ra = new RenderArgs(new Surface(input.Size));
			input.Render(ra, true);

			ra.Bitmap.Save(output, System.Drawing.Imaging.ImageFormat.Png);
		}

		FileType[] IFileTypeFactory.GetFileTypeInstances()
		{
			return new[] { new DMIFileType() };
		}
	}
}
