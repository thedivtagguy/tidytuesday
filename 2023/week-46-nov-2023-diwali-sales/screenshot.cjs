const puppeteer = require("puppeteer");

async function takeScreenshot(fileDetails) {
  const browser = await puppeteer.launch();

  for (const detail of fileDetails) {
    const page = await browser.newPage();
    const localFilePath = `file://${__dirname}/${detail.file}`;
    await page.goto(localFilePath, { waitUntil: "networkidle0" });

    // Screenshot with width 1200
    await page.setViewport({
      width: 700,
      height: 800,
      deviceScaleFactor: 8,
    });

    const selector = detail.selector;
    await page.waitForSelector(selector);
    const element = await page.$(selector);
    await element.screenshot({ path: `${detail.file.split(".")[0]}_w.png` });

    // Screenshot with width 500
    await page.setViewport({
      width: 500,
      height: 800,
      deviceScaleFactor: 4,
    });
    await element.screenshot({ path: `${detail.file.split(".")[0]}_s.png` });

    await page.close();
  }

  await browser.close();
}

// Array of file details with selectors
const fileDetails = [
  { file: "tables.html", selector: "#lgjgjhlnuz" },
  // { file: "investments.html", selector: "#ywsxssyfmq" }, // Specify the selector for each file
];
takeScreenshot(fileDetails);
