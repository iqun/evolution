// Show summary
("SUMMARY\nOrganisms:" + Archive.global.at(\organisms).size).postln;
("Codons:" + Archive.global.at(\codons).size).postln;
("Habitats:" + Archive.global.at(\habitats).size).postln;
Archive.global.at(\habitats).keysValuesDo({|key, value| ("\t" + key ++ ":" + value.size).postln;});"";

// Show codons
Archive.global.at(\codons).do({|codon| codon.at(\id).postln;(("\t") + codon.at(\return)).postln;(("\t") + codon.at(\arguments)).postln;(("\t") + codon.at(\function).def.sourceCode).postln;});"";
Archive.global.at(\codons).put(\random, Archive.global.at(\savedCodons).at(\random))

// Create new event codon
c = Codon.create(Event.class.asString, 10);

// Show codon
c.post;

// Play codon
c.value().play;





// Add codon
Archive.global.at(\codons).put(\fractal, Dictionary[
	\id -> \fractal,
	\function -> {|p,d| (d <= 0).if({0}, {Pseq(p + Array.fill(p.size, thisFunction.value(p, d - 1)))})},
	\arguments -> [Pattern.class.asString, Integer.class.asString],
	\return -> Pattern.class.asString,
]);



// Save archive
Archive.archiveDir="/Users/bdoyle/sandbox/supercollider";
Archive.read("/Users/bdoyle/sandbox/supercollider/archive.sctxar").at(\codons);
Archive.read().at(\codons);
f = {|p,d| (d <= 0).if({0}, {Pseq(p + Array.fill(p.size, thisFunction.value(p, d - 1)))})};
Archive.archiveDir