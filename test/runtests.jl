
using ReadSniper
using Test
using Logging

using BioSequences, FASTX

Logging.global_logger(SimpleLogger(stdout, Logging.Warn))

@testset "utils.jl" begin
    @test length(LISE([1,7,14,4,5,4,6,15])) == 5
    @test length(LISE([20,1,7,14,4,5,5,6,15])) == 5
    println(LISE([20,1,7,14,4,5,5,6,15]))
    println(longest_span_sequence(LISE([20,1,7,14,4,5,5,6,15]), 10))
    #@test length(longest_span_sequence(LISE([20,1,7,14,4,5,5,6,15]), 10)) == 4
    
    dict = Dict(1 => 1, 2 => 1)
    increment_dict_value!(1, 1, dict)
    @test dict == Dict(1 => 2, 2 => 1)
end


@testset "randutils.jl" begin
    @test gc_content(random_dna(10000, 0.1)) < 0.2
    @test gc_content(random_dna(10000, 0.9)) > 0.8
end


@testset "kmers.jl" begin
    @test create_kmer_vector(dna"ACGTACGT", 4) == [dna"ACGT", dna"CGTA", dna"GTAC", dna"TACG", dna"ACGT"]

    @test kmer_index_dict(dna"ACGTACGT", 4, false) == Dict(dna"ACGT" => [5, 1], dna"CGTA" => [2], dna"GTAC" => [3], dna"TACG" => [4])
    @test kmer_match_indices(dna"ACGTTCGTA", kmer_index_dict(dna"ACGTACGT", 4, false), 4) == [[5, 1], Int64[], Int64[], Int64[], Int64[], [2]]
end


@testset "reads.jl" begin
    #@test max_subseq_in_range([1,6,7,8,9,10,11,12,13,17], 8, length) == (8, 2, 9)

    @testset begin
        config = Config(7, 1, 20, 1)

        reader = FASTAReader(open("SRR123.fasta", "r"))
        record1 = first(reader)
        record2 = first(reader)
        record3 = first(reader)
        close(reader)

        reader = FASTAReader(open("test_reference.fasta", "r"))
        kmer_dict = kmer_index_dict(sequence(LongDNA{4}, first(reader)), config.k, true)
        close(reader)

        # Test whether the returned scores show a correlation or not
        @test scan_read(config, record1, kmer_dict)[1] > config.threshold
        @test scan_read(config, record2, kmer_dict)[1] > config.threshold
        @test scan_read(config, record3, kmer_dict)[1] < config.threshold
    end
end


@testset "datasets.jl" begin
    @testset "Reference" begin
        k = 7
        reference = Reference("test_reference.fasta", k)
        @test round(reference.gc_content, digits=2) == 0.31
        @test reference.length == 9369
        @test reference.unique_kmer_count <= 2 * (9369 - k + 1)
    end

    @testset "DatafileMetadata" begin
        datafile = DatafileMetadata("SRR123.fasta")
        #@test datafile.file_size
        @test datafile.read_count == 3
        @test datafile.read_length == 100
        #@test datafile.gc_content
    end
end


@testset "probability.jl" begin
    @test sum(P_ACGT(0.5)) == 1 
end


@testset "iteration.jl" begin
    
end


@testset "plots.jl" begin
    
end


@testset "main.jl" begin
    reads = snipe_reads(
        "test_reference.fasta",
        ["SRR123.fasta"],
        k = 7,
        step = 1,
        save_data = false,
        create_plots = false,
        show_progress = false,
    )
    @test Set(reads.read_index) == Set([1, 2])
end